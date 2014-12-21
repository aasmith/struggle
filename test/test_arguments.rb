require "helper"

class ArgumentsTest < Struggle::Test

  def test_arguments
    target = Target.new(a: 1, b: 2)

    assert_equal 1, target.a
    assert_equal 2, target.b
  end

  class Target
    fancy_accessor :a, :b

    def initialize(a:, b:)
      self.a = a
      self.b = b
    end
  end

end
