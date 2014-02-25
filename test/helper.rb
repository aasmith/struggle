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

# No dot printing right now, thx
#module Minitest
#  class ProgressReporter
#    undef record
#    def record _
#    end
#  end
#end
