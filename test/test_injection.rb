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

  def test_injector_does_nothing_on_non_injectibles
    source = Struct.new(:a).new(123)
    innocent_bystander = Struct.new(:a).new

    injector = Injector.new(source)

    injector.inject(innocent_bystander)

    refute innocent_bystander.a,
      "Should not be injected because no needs were supplied"
  end

  def test_injector_injects_arguments
    needy_wrapper = NeedyWrapper.new
    needy_wrapper.foo = @needy
    needy_wrapper.bar = Object.new

    source = Struct.new(:a, :b).new(123, 456)
    injector = Injector.new(source)

    injector.inject(needy_wrapper)

    assert_equal 123, needy_wrapper.a

    assert_equal 123, @needy.a, "Nested targets should be injected"
    assert_equal 456, @needy.b, "Nested targets should be injected"
  end

  def test_injector_unwraps_pointers
    source = Struct.new(:a, :b).new(123, Pointer.new)
    injector = Injector.new(source)

    refute @needy.a, "Should be nil"
    refute @needy.b, "Should be nil"

    injector.inject(@needy)

    assert_equal 123, @needy.a, "Injector should provide value from source"
    assert_equal 789, @needy.b, "Injector should provide value from pointer"
  end

  def test_injector_doesnt_unwrap_pointers_when_raw_requested
    source = Struct.new(:a, :b).new(123, p=Pointer.new)
    injector = Injector.new(source)

    def @needy.needs_raw?
      true
    end

    refute @needy.a, "Should be nil"
    refute @needy.b, "Should be nil"

    injector.inject(@needy)

    assert_equal 123, @needy.a, "Injector should provide value from source"
    assert_equal p,   @needy.b, "Injector should provide pointer"
  end

  class Needy
    extend Injectible

    needs :a, :b
  end

  class NeedyWrapper
    extend Injectible

    needs :a

    fancy_accessor :foo, :bar
  end

  class Pointer
    def __value__
      789
    end
  end

end
