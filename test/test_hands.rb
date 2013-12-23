require "helper"

class HandsTest < Struggle::Test

  def test_new
    h = Hands.new

    assert h.get(US).empty?
    assert h.get(USSR).empty?
  end

  def test_hands_are_frozen
    h = Hands.new
    c = Object.new

    h.add(USSR, c)

    ex = assert_raises(RuntimeError) do
      h.get(USSR) << Object.new
    end

    assert_match /can't modify frozen Array/, ex.message
  end

  def test_add
    h = Hands.new
    c = Object.new

    h.add(USSR, c)

    assert_equal [c], h.get(USSR), "USSR should have one card in their hand"
    assert_equal [],  h.get(US),   "US should have no cards in their hand"
  end
end
