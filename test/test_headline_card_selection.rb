require "helper"

class TestHeadlineCardSelection < Struggle::Test

  def setup
    @zero  = Card.new(name: "", ops: 0)
    @one   = Card.new(name: "", ops: 1)
    @first = Card.new(name: "", ops: 0, always_evaluate_first: true)
  end

  def test_us_wins_draw
    selections = [
      ussr = HeadlineCardSelection.new(USSR, @zero),
      us   = HeadlineCardSelection.new(US,   @zero)
    ]

    selections.sort!

    assert_equal [us, ussr], selections, "US should win playing same card value"
  end

  def test_ussr_wins_when_higher
    selections = [
      us   = HeadlineCardSelection.new(US,   @zero),
      ussr = HeadlineCardSelection.new(USSR, @one)
    ]

    selections.sort!

    assert_equal [ussr, us], selections, "USSR should win playing high card"
  end

  def test_us_wins_when_higher
    selections = [
      ussr = HeadlineCardSelection.new(USSR, @zero),
      us   = HeadlineCardSelection.new(US,   @one)
    ]

    selections.sort!

    assert_equal [us, ussr], selections, "US should win playing high card"
  end

  def test_defectors_always_wins
    selections = [
      us   = HeadlineCardSelection.new(US,   @one),
      ussr = HeadlineCardSelection.new(USSR, @first)
    ]

    selections.sort!

    assert_equal [ussr, us], selections,
      "Card with 'always_evaluate_first' should always win"
  end

  def test_fails_when_players_same
    selections = [
      HeadlineCardSelection.new(US, @one),
      HeadlineCardSelection.new(US, @first)
    ]

    ex = assert_raises do
      selections.sort!
    end

    assert_equal "Players must differ", ex.message
  end

end
