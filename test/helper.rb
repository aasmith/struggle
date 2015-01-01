require "minitest/autorun"
require "minitest/mock"

require "struggle"

# Silence log during tests
$logging = false

class Struggle::Test < Minitest::Test
  parallelize_me!
  make_my_diffs_pretty!

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


# No dot printing right now, thx
#module Minitest
#  class ProgressReporter
#    undef record
#    def record _
#    end
#  end
#end
