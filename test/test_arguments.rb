require "helper"

class ArgumentsTest < Struggle::Test

  def test_arguments
    target = Target.new(1,2)

    assert_equal 1, target.a
    assert_equal 2, target.b
  end

  def test_too_many_arguments
    assert_raises(ArgumentError) do
      Target.new(1,2,3)
    end
  end

  def test_too_few_arguments
    assert_raises(ArgumentError) do
      Target.new(1)
    end
  end

  class Target
    extend Arguments

    def initialize(*args)
      ArgumentProvider.new(self).provide(args)
    end

    arguments :a, :b
  end
end
