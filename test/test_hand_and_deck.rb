require "minitest/autorun"

require "s"

class TestHandAndDeck < MiniTest::Unit::TestCase

  def setup
    build_deck
    @backup = Deck.new([:x, :y, :z])
  end

  def build_deck
    @deck = Deck.new([:a, :b, :c])
  end

  def test_deck_draw_uses_backup_if_provided
    deck = Deck.new([:a, :b, :c], @backup)

    3.times { assert [:a, :b, :c].include?(deck.draw) }
    3.times { assert [:x, :y, :z].include?(deck.draw) }
  end

  def test_draw
    assert_equal @deck.cards.size, 3
    assert [:a, :b, :c].include?(@deck.draw)
    assert_equal @deck.cards.size, 2
  end

  def test_deck_is_shuffled
    results = 100.times.map do
      build_deck

      [@deck.draw, @deck.draw, @deck.draw]
    end

    assert results.uniq.size > 1, <<-MSG
      After 100 iterations, the deck never appeared to be shuffled
    MSG
  end
end
