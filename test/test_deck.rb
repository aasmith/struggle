require "helper"

class DeckTest < Struggle::Test

  def test_draw_removes_cards
    deck  = Deck.new
    cards = [1,2,3]

    assert_nil deck.add(cards), "Deck#add should alwways return nil"

    assert_includes cards, deck.draw
    assert_includes cards, deck.draw
    assert_includes cards, deck.draw

    assert deck.empty?, "Should be no cards left after drawing the whole deck"
  end

  def test_add_shuffles_deck
    deck  = Deck.new
    cards = [1,2,3]

    assert_nil deck.add(cards), "Deck#add should alwways return nil"

    draws = []

    100.times do
      draws << [deck.draw, deck.draw, deck.draw]
      deck.add(cards)
    end

    assert draws.uniq.size > 1, "After 100 iterations, draw order never varied"
  end

  def test_empty?
    deck = Deck.new
    assert deck.empty?, "A new deck should be empty"

    deck.add([Object.new])
    refute deck.empty?, "Cannot be empty after adding card"

    deck.draw
    assert deck.empty?, "Only card should have been removed"
  end
end
