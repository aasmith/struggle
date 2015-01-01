require "helper"

class HandsTest < Struggle::Test

  def test_new
    h = Hands.new

    assert h.get(US).empty?
    assert h.get(USSR).empty?
  end

  def test_any_returned_hands_are_frozen
    h = Hands.new
    c = Object.new

    h.add(USSR, c)

    assert h.get(USSR).frozen?,    "Hand should be frozen"
    refute h.get!(USSR).frozen?,   "Hand should not be frozen when using get!"
    assert h.clear(USSR).frozen?,  "Hand should not be modifiable via clear"
    assert h.add(USSR, c).frozen?, "Hand should not be modifiable via add"
  end

  def test_any_returned_hands_are_dups
    h = Hands.new
    c = Object.new

    h.add(USSR, c)

    assert_equal h.get(USSR), h.get(USSR)
    refute_same  h.get(USSR), h.get(USSR)
  end

  def test_add
    h = Hands.new
    c = Object.new

    h.add(USSR, c)

    assert_equal [c], h.get(USSR), "USSR should have one card in their hand"
    assert_equal [],  h.get(US),   "US should have no cards in their hand"

    h.add(US, c)

    assert_equal [c], h.get(USSR), "USSR should have one card in their hand"
    assert_equal [c], h.get(US),  "US should have one card in their hand"
  end

  def test_remove
    h = Hands.new
    c = Object.new

    h.add(USSR, c)

    assert_equal c, h.remove(USSR, c), "Should return removed card"

    assert_nil h.remove(USSR, c), "Should return nil if the card is not present"
  end

  def test_clear
    h = Hands.new
    c = Object.new

    h.add(USSR, c)
    h.add(US, c)

    assert_equal [],  h.clear(USSR), "USSR should have no cards"
    assert_equal [c], h.get(US), "US hand should still be populated"
  end
end
