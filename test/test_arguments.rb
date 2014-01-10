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

    assert_match(/too many args/, ex.message)
  end

  def test_too_few_arguments
    ex = assert_raises(ArgumentError) do
      Target.new(a: 1)
    end

    assert_match(/missing args/, ex.message)
  end

  def test_dynamic_arguments_evaluated_at_runtime
    dynamic = DynamicValue.new
    target  = Target.new(a: 1, b: dynamic)

    assert_equal 1, target.a

    assert_equal 11, target.b, "Should delegate to the dynamic value provider"
    assert_equal 12, target.b, "Dynamic values should not be cached"

    assert_equal dynamic, target.b(unbox: false), "Value should not be unboxed"
  end

  class Target
    extend Arguments

    def initialize(**args)
      ArgumentProvider.new(self).provide(args)
    end

    arguments :a, :b
  end

  class DynamicValue
    def initialize
      @val = 10
    end

    def value
      @val += 1
    end
  end
end
