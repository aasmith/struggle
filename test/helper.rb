require "minitest/autorun"
require "minitest/mock"

require "struggle"

class Struggle::Test < Minitest::Test
end

module InstructionTests end
module ArbitratorTests end

# Commonly used fake / empty test classes

class EmptyMove < Move
  def initialize(*)
    super

    @executed = false
  end

  def execute
    @executed = true
  end

  def executed?
    @executed
  end
end

