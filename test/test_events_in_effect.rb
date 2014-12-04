require "helper"

class TestEventsInEffect < Struggle::Test

  def setup
    @e = EventsInEffect.new([:a])
  end

  def test_initialize
    e = EventsInEffect.new
    refute e.any?

    e = EventsInEffect.new([:a, :b])
    assert_equal %i(a b), e.to_a
  end

  def test_add
    @e.add :b
    assert @e.include? :b
  end

  def test_remove
    assert @e.include? :a
    @e.remove :a
    refute @e.include? :a
  end

end

