require "helper"

class ArgumentsTest < Struggle::Test

  def test_arguments
    target = Target.new(a: 1, b: 2)

    assert_equal 1, target.a
    assert_equal 2, target.b
  end

  def test_too_many_arguments
    ex = assert_raises(ArgumentError) do
      Target.new(a: 1, b: 2, c: 3)
    end

    assert_match(/Too many args/, ex.message)
  end

  def test_too_few_arguments
    ex = assert_raises(ArgumentError) do
      Target.new(a: 1)
    end

    assert_match(/Missing args/, ex.message)
  end

  class Target
    extend Arguments

    def initialize(**args)
      ArgumentProvider.new(self).provide(args)
    end

    arguments :a, :b
  end
end
