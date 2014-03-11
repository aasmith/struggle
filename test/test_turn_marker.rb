require "helper"

class TurnMarkerTest < Struggle::Test

  def test_advance
    turn = TurnMarker.new
    assert_equal 1, turn.number

    turn.advance
    assert_equal 2, turn.number
  end

  def test_phases
    turn = TurnMarker.new

    (1..3).each do |n|
      assert turn.early_phase?, "Turn #{n} should be early phase"
      refute turn.mid_phase?
      refute turn.late_phase?

      turn.advance
    end

    (4..7).each do |n|
      refute turn.early_phase?
      assert turn.mid_phase?, "Turn #{n} should be mid phase"
      refute turn.late_phase?

      turn.advance
    end

    (8..10).each do |n|
      refute turn.early_phase?
      refute turn.mid_phase?
      assert turn.late_phase?, "Turn #{n} should be late phase"

      turn.advance
    end
  end

end
