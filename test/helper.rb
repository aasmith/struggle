require "minitest/autorun"
require "minitest/mock"

require "struggle"

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

