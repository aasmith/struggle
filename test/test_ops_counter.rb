require "helper"

class OpsCounterTest < Struggle::Test

  attr_accessor :cc, :vr, :ct, :rs

  Country = Struct.new(:name)

  India = Country.new(:India)
  Burma = Country.new(:Burma)
  Kenya = Country.new(:Kenya)

  Africa = [Kenya]
  Asia   = [India, Burma]
  SeAsia = [Burma]

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
    self.cc = OpsModifier.new(player: US, amount: 1, countries: Asia)

    # vietnam revolts; +1 when all in se asia
    self.vr = OpsModifier.new(player: US, amount: 1, countries: SeAsia)

    # containment/brezhnev; +1 without condition
    self.ct = OpsModifier.new(player: US, amount: 1)

    # red scare; -1 without condition
    self.rs = OpsModifier.new(player: US, amount: -1)
  end

  # TODO the names of these tests are terrible.

  def test_basic
    c = OpsCounter.new 3

    assert c.accepts? asia(3)
    c.accept          asia(3)
    assert c.done?
  end

  def test_unconditional_increase
    c = OpsCounter.new 2, [ct]

    assert c.accepts? asia(3)
    c.accept          asia(3)
    assert c.done?
  end

  def test_unconditional_decrease
    c = OpsCounter.new 2, [rs]

    assert c.accepts? asia
    c.accept          asia
    assert c.done?
  end

  # Example from 7.4
  def test_upper_bounds_of_mixed_conditionals
    c = OpsCounter.new 4, [cc, rs, vr]

    assert c.accepts? seasia(5)
    c.accept          seasia(5)
    assert c.done?
  end

  def test_upper_bounds_of_mixed_conditionals_variant
    c = OpsCounter.new 4, [rs, vr]

    assert c.accepts? seasia(4)
    c.accept          seasia(4)
    assert c.done?
  end

  def test_lower_bounds_of_mixed_conditionals
    c = OpsCounter.new 1, [rs, vr]

    assert c.accepts? seasia
    c.accept          seasia
    assert c.done?
  end

  def test_lower_bounds_of_unconditionals
    c = OpsCounter.new 1, [rs]

    assert c.accepts? seasia
    c.accept          seasia
    assert c.done?
  end

  def test_upper_bounds_of_unconditionals
    c = OpsCounter.new 4, [ct]

    assert c.accepts? seasia(4)
    c.accept          seasia(4)
    assert c.done?
  end

  def test_upper_bounds_of_unconditionals_with_conditional
    c = OpsCounter.new 3, [ct, vr]

    assert c.accepts? seasia(5)
    c.accept          seasia(5)
    assert c.done?

    c = OpsCounter.new 3, [ct, vr]

    assert c.accepts? asia(4)
    c.accept          asia(4)
    assert c.done?
  end

  def test_extra_when_all_in_subregion_in_multiple_moves
    c = OpsCounter.new 3, [vr]

    assert c.accepts? seasia(3)
    c.accept          seasia(3)
    refute c.done?

    refute c.accepts?([Kenya]), "Should reject countries outside a valid region"

    assert c.accepts? seasia
    c.accept          seasia
    assert c.done?
  end

  def test_extra_when_all_in_subregion_in_one_move
    c = OpsCounter.new 3, [vr]

    assert c.accepts? seasia(4)
    c.accept          seasia(4)
    assert c.done?
  end

  def test_extra_only_triggers_when_all_moves_match
    c = OpsCounter.new 3, [vr]

    assert c.accepts? [Burma, Burma, India]
    c.accept          [Burma, Burma, India]
    assert c.done?
  end

  def test_extra_only_allows_extra_amount
    c = OpsCounter.new 3, [vr]

    refute c.accepts? seasia(5)
  end

  def test_stacking_extras_when_all_in_subregion_in_one_move
    c = OpsCounter.new 3, [vr, cc]

    assert c.accepts? seasia(5)
    c.accept          seasia(5)
    assert c.done?
  end

  def test_stacking_extras_when_all_in_subregion_in_multiple_moves
    c = OpsCounter.new 3, [vr, cc]

    assert c.accepts? seasia(3)
    c.accept          seasia(3)
    refute c.done?

    assert c.accepts? seasia(2)
    c.accept          seasia(2)
    assert c.done?
  end

  def test_stacking_extras_when_all_in_region_in_multiple_moves
    c = OpsCounter.new 3, [vr, cc]

    assert c.accepts? asia(3)
    c.accept          asia(3)
    refute c.done?

    assert c.accepts? asia
    c.accept          asia
    assert c.done?
  end

  # Test value_for_country resolution

  def test_value_for_country
    c = OpsCounter.new 3

    assert_equal 3, c.value_for_country(Kenya)
  end

  def test_value_for_country_conditional
    c = OpsCounter.new 3, [cc, vr]

    assert_equal 3, c.value_for_country(Kenya)
    assert_equal 4, c.value_for_country(India)
    assert_equal 5, c.value_for_country(Burma)
  end

  def test_value_for_country_unconditional
    c = OpsCounter.new 3, [rs]

    assert_equal 2, c.value_for_country(Burma)
  end

  def test_value_for_country_both_condition_types
    c = OpsCounter.new 3, [rs, cc, vr]

    assert_equal 2, c.value_for_country(Kenya)
    assert_equal 3, c.value_for_country(India)
    assert_equal 4, c.value_for_country(Burma)
  end
end
