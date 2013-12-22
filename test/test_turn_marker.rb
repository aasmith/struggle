require "helper"

class TurnMarkerTest < Struggle::Test

  def test_advance
    turn = TurnMarker.new
    assert_equal 1, turn.number

    turn.advance
    assert_equal 2, turn.number
  end
end
