require "helper"

class TestInjection < Struggle::Test

  def setup
    @needy = Needy.new
  end

  def test_needs_adds_accessors
    @needy.a = 1
    @needy.b = 2

    assert_equal 1, @needy.a
    assert_equal 2, @needy.b
  end

  def test_needs_lists_needs
    assert_equal %i(a b), @needy.class.needs
  end

  def test_injector_fulfils_needs
    source = Struct.new(:a, :b).new(123, 456)
    injector = Injector.new(source)

    refute @needy.a, "Should be nil"
    refute @needy.b, "Should be nil"

    injector.inject(@needy)

    assert_equal 123, @needy.a, "Injector should provide value from source"
    assert_equal 456, @needy.b, "Injector should provide value from source"
  end

  def test_injector_raises_on_unfulfilled_needs
    incomplete_source = Struct.new(:a).new(123)
    injector = Injector.new(incomplete_source)

    assert_raises(Injector::InadequateSourceError) do
      injector.inject(@needy)
    end
  end

  class Needy
    extend Injectible

    needs :a, :b
  end
end
