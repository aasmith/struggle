require "minitest/autorun"
require "minitest/mock"

require "struggle"

# Silence log during tests
$logging = false

class Struggle::Test < Minitest::Test
  parallelize_me!
  make_my_diffs_pretty!
end

module InstructionTests end
module ArbitratorTests end

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


# No dot printing right now, thx
#module Minitest
#  class ProgressReporter
#    undef record
#    def record _
#    end
#  end
#end
