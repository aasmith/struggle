require "helper"

class DealCardsTest < Struggle::Test

  def test_deal
    cards = Cards.new.select { |c| c.early? }

    deck = Deck.new
    deck.add cards

    orig_size = deck.size

    hands = Hands.new
    hands.add(US, Object.new)
    hands.add(USSR, Object.new)

    instruction = Instructions::DealCards.new(target: 8)

    instruction.deck  = deck
    instruction.hands = hands
    instruction.discards = []

    instruction.action

    assert_equal 8, hands.get(US).size, "US should end with 8 cards"
    assert_equal 8, hands.get(USSR).size, "USSR should end with 8 cards"

    all = [*hands.get(US), *hands.get(USSR)]

    assert_equal all.size, all.uniq.size, "A card should appear once at most"

    assert_equal 14, orig_size - deck.size,
      "14 cards should have been dealt from the deck"
  end

  def test_dealing_rotates_between_players
    expected_order = %w(USSR US USSR US USSR US USSR US)

    cards = [Object.new] * 8
    hands = FakeConjoinedHand.new

    deck = Deck.new
    deck.add cards

    instruction = Instructions::DealCards.new(target: 4)

    instruction.deck  = deck
    instruction.hands = hands
    instruction.discards = []

    instruction.action

    assert_equal expected_order, hands.master.map { |e| e.player },
      "Deal order should rotate between players per rule 11.1.4"
  end

  def test_uneven_deal
    expected_order = %w(USSR US USSR US USSR USSR)

    cards = [Object.new] * 10

    deck = Deck.new
    deck.add cards

    # US starts with 4 cards, USSR with 2.
    hands = FakeConjoinedHand.new
    4.times { hands.add_quietly(US, Object.new) }
    2.times { hands.add_quietly(USSR, Object.new) }

    instruction = Instructions::DealCards.new(target: 6)

    instruction.deck  = deck
    instruction.hands = hands
    instruction.discards = []

    instruction.action

    assert_equal expected_order, hands.master.map { |e| e.player } ,
      "Should give an even deal for as long as possible"

  end

  def test_dealing_uses_discard_upon_empty
    expected_order = %w(c c c d d d d d d d d d)

    cards = %w(c c c)
    discards = %w(d d d d d d d d d d d d)

    deck = Deck.new
    deck.add cards

    hands = FakeConjoinedHand.new

    instruction = Instructions::DealCards.new(target: 6)

    instruction.deck  = deck
    instruction.hands = hands
    instruction.discards = discards

    instruction.action

    assert_equal expected_order, hands.master.map { |e| e.card },
      "All regular cards should be dealt before dealing discards"
  end

  # A hand that shares.
  class FakeConjoinedHand < Hands
    def initialize
      super
      @master = []
    end

    def add_quietly(player, card)
      add(player, card, true)
    end

    def add(player, card, quiet = false)
      super(player, card)
      @master << Entry.new(player.to_s, card.to_s) unless quiet
    end

    def master
      @master
    end

    Entry = Struct.new(:player, :card)
  end
end
