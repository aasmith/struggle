require "minitest/autorun"
require "minitest/proveit"

require "struggle"

# Silence log during tests
$logging = false

# Generate this immutable instance once and keep it around for all tests.
TEST_CARDS = Cards.new.freeze

module Assertions
  def assert_instruction(thing)
    assert_kind_of Instruction, thing
  end

  def assert_permission_added(permission_name, instruction)
    assert_instruction instruction
    assert_instance_of Instructions::AddPermissionModifier, instruction
    assert_equal permission_name, instruction.modifier_name
  end

  def assert_placed_in_effect(card_ref, instruction)
    assert_instruction instruction
    assert_instance_of Instructions::PlaceInEffect, instruction
    assert_equal card_ref, instruction.card_ref
  end

  def assert_removed_from_play(card_ref, instruction)
    assert_instruction instruction
    assert_instance_of Instructions::Remove, instruction
    assert_equal card_ref, instruction.card_ref
  end

  def assert_discard(card_ref, instruction)
    assert_kind_of Instructions::Discard, instruction
    assert_equal card_ref, instruction.card_ref
  end

  def assert_remove(card_ref, instruction)
    assert_kind_of Instructions::Remove, instruction
    assert_equal card_ref, instruction.card_ref
  end

  def assert_award_vp(amount, player, instruction)
    assert_kind_of Instructions::AwardVictoryPoints, instruction
    assert_equal amount, instruction.amount
    assert_equal player, instruction.player
  end

end

class Struggle::Test < Minitest::Test

  include Assertions

  parallelize_me!
  make_my_diffs_pretty!
  prove_it!

  def generate_countries(*names)
    names.map do |name|
      [name, 1, false, "Region", []]
    end
  end

end

module InstructionTests end
module ArbitratorTests end
module GuardTests end
module ModifierTests end
module CardEventTests end

# Commonly used fake / empty test classes

class EmptyMove < Move
  def initialize(**args)
    @label = args.delete(:label)
    super(args)

    @executed = false
  end

  def execute
    @executed = true
  end

  def executed?
    @executed
  end
end

class EmptyInstruction < Instruction
  def action
  end
end

class FakeCountries < Struct.new(:country)
  def find(x)
    country
  end
end

class OneSidedDie
  def initialize(n)
    @n = n
  end

  def roll
    @n
  end
end

class ProgrammedDie
  def initialize(*seq)
    @seq = seq.dup
  end

  def roll
    @seq.shift or raise SequenceEmpty, "No more rolls left in sequence"
  end

  SequenceEmpty = Class.new(ArgumentError)
end

# A counter that doesnt expect any modifers, applies no bounds,
# and therefore has a very simple life.

class SimpleOpsCounter
  def initialize(amount)
    @amount = amount
  end

  def accepts?(things)
    @amount - things.size >= 0
  end

  def accept(things)
    @amount -= things.size
  end

  def done?
    @amount.zero?
  end
end


# A DEFCON that knows only the extremes.

class BlanketDefcon
  def initialize(prevents_everything:)
    @prevents_everything = prevents_everything
  end

  def affects?(*)
    @prevents_everything
  end
end

class FakeEventFinder
  def find(name, type = EVENT)
    Instructions::Noop.new(label: [name,type].join(":"))
  end
end

class FakeInjector
  def initialize
    @injected = []
  end

  def inject(target)
    @injected << target
  end

  def injected?(thing)
    @injected.include? thing
  end
end


# No dot printing right now, thx
#module Minitest
#  class ProgressReporter
#    undef record
#    def record _
#    end
#  end
#end
