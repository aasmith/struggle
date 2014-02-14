# This spike contains a solution for the resolving & spending of
# extra conditional points.

require "pp"

class ExtraCount
  attr_reader :amount

  def initialize(amount, **args)
    @amount = amount
    @conds = [*args[:all]]
  end

  def conditional?
    !unconditional?
  end

  def unconditional?
    @conds.empty?
  end

  def qualifies?(countries)
    if unconditional?
      return true
    else
      countries.all? do |country|
        @conds.any? do |cond|
          country.in? cond
        end
      end
    end
  end
end

class Counter
  def initialize(count, *extras)
    @sequences = []

    conditionals   = extras.select &:conditional?
    unconditionals = extras.select &:unconditional?

    @possibles = { [] => bound(count + sum(unconditionals)) }

    1.upto(conditionals.size) do |i|
      conditionals.combination(i).each do |combination|
        @possibles[combination] = bound(count) +
                                  sum(unconditionals) +
                                  sum(combination)
      end
    end
  end

  def bound(number)
    [[number, 1].max, 4].min
  end

  def sum(extras)
    extras.map(&:amount).reduce(:+) || 0
  end

  def all_extras_qualify?(sequence = [], extras, count)
    sequences = @sequences + sequence

    extras.all? { |e| e.qualifies?(sequences) } && sequence.size <= count
  end

  def accepts?(*sequence)
    return false if done?

    @possibles.any? do |extras, count|
      all_extras_qualify?(sequence, extras, count)
    end
  end

  def accept(*sequence)
    raise ArgumentError, "Invalid sequence" unless accepts?(*sequence)

    @possibles.each do |extras, count|
      if all_extras_qualify?(sequence, extras, count)
        @possibles[extras] -= sequence.size
      else
        @possibles[extras] = 0
      end
    end

    @sequences += sequence
  end

  def done?
    @possibles.all? do |extras, count|
      count.zero? || !all_extras_qualify?(extras, count)
    end
  end
end


require "minitest/autorun"

class Country
  def initialize(name, *regions)
    @name = name
    @regions = regions
  end

  def in?(region)
    @regions.include? region
  end

  def inspect
    "%s (%s)" % [@name, @regions.join(", ")]
  end
end

class TestCounter < Minitest::Test

  attr_accessor :cc, :vr, :ct, :rs

  India = Country.new("India", :asia)
  Burma = Country.new("Burma", :asia, :seasia)
  Kenya = Country.new("Kenya", :africa)

  def asia(num = 1)
    [India] * num
  end

  def seasia(num = 1)
    [Burma] * num
  end

  def other(num = 1)
    [Kenya] * num
  end

  def setup
    # china card; +1 when all in asia
    self.cc = ExtraCount.new(1, all: :asia)

    # vietnam revolts; +1 when all in se asia
    self.vr = ExtraCount.new(1, all: :seasia)

    # containment/brezhnev; +1 without condition
    self.ct = ExtraCount.new(1)

    # red scare; -1 without condition
    self.rs = ExtraCount.new(-1)
  end

  def test_basic
    c = Counter.new 3

    assert c.accepts? *asia(3)
    c.accept          *asia(3)
    assert c.done?
  end

  def test_unconditional_increase
    c = Counter.new 2, ct

    assert c.accepts? *asia(3)
    c.accept          *asia(3)
    assert c.done?
  end

  def test_unconditional_decrease
    c = Counter.new 2, rs

    assert c.accepts? *asia
    c.accept          *asia
    assert c.done?
  end

  # Example from 7.4
  def test_upper_bounds_of_mixed_conditionals
    c = Counter.new 4, cc, rs, vr

    assert c.accepts? *seasia(5)
    c.accept          *seasia(5)
    assert c.done?
  end

  def test_lower_bounds_of_mixed_conditionals
    c = Counter.new 1, rs, vr

    assert c.accepts? *seasia
    c.accept          *seasia
    assert c.done?
  end

  def test_lower_bounds_of_unconditionals
    c = Counter.new 1, rs

    assert c.accepts? *seasia
    c.accept          *seasia
    assert c.done?
  end

  def test_upper_bounds_of_unconditionals
    c = Counter.new 4, ct

    assert c.accepts? *seasia(4)
    c.accept          *seasia(4)
    assert c.done?
  end

  def test_extra_when_all_in_subregion_in_multiple_moves
    c = Counter.new 3, vr

    assert c.accepts? *seasia(3)
    c.accept          *seasia(3)
    refute c.done?

    refute c.accepts?(Kenya), "Should reject countries outside a valid region"

    assert c.accepts? *seasia
    c.accept          *seasia
    assert c.done?
  end

  def test_extra_when_all_in_subregion_in_one_move
    c = Counter.new 3, vr

    assert c.accepts? *seasia(4)
    c.accept          *seasia(4)
    assert c.done?
  end

  def test_extra_only_triggers_when_all_moves_match
    c = Counter.new 3, vr

    assert c.accepts? Burma, Burma, India
    c.accept          Burma, Burma, India
    assert c.done?
  end

  def test_extra_only_allows_extra_amount
    c = Counter.new 3, vr

    refute c.accepts? *seasia(5)
  end

  def test_stacking_extras_when_all_in_subregion_in_one_move
    c = Counter.new 3, vr, cc

    assert c.accepts? *seasia(5)
    c.accept          *seasia(5)
    assert c.done?
  end

  def test_stacking_extras_when_all_in_subregion_in_multiple_moves
    c = Counter.new 3, vr, cc

    assert c.accepts? *seasia(3)
    c.accept          *seasia(3)
    refute c.done?

    assert c.accepts? *seasia(2)
    c.accept          *seasia(2)
    assert c.done?
  end

  def test_stacking_extras_when_all_in_region_in_multiple_moves
    c = Counter.new 3, vr, cc

    assert c.accepts? *asia(3)
    c.accept          *asia(3)
    refute c.done?

    assert c.accepts? *asia
    c.accept          *asia
    assert c.done?
  end
end

