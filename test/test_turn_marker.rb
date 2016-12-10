require "helper"

class TurnMarkerTest < Struggle::Test

  def setup
    @turn = TurnMarker.new
    @turn.start
  end

  def test_initialize
    turn = TurnMarker.new

    refute turn.number,       "A new TurnMarker should not have a number"
    refute turn.early_phase?, "A new TurnMarker should not have a phase"
    refute turn.mid_phase?,   "A new TurnMarker should not have a phase"
    refute turn.late_phase?,  "A new TurnMarker should not have a phase"
  end

  def test_start
    assert_equal 1, @turn.number, "A newly started TurnMarker should be at 1"
  end

  def test_advance
    assert_equal 1, @turn.number

    @turn.advance
    assert_equal 2, @turn.number
  end

  def test_phases
    (1..3).each do |n|
      assert @turn.early_phase?, "Turn #{n} should be early phase"
      refute @turn.mid_phase?
      refute @turn.late_phase?

      @turn.advance
    end

    (4..7).each do |n|
      refute @turn.early_phase?
      assert @turn.mid_phase?, "Turn #{n} should be mid phase"
      refute @turn.late_phase?

      @turn.advance
    end

    (8..10).each do |n|
      refute @turn.early_phase?
      refute @turn.mid_phase?
      assert @turn.late_phase?, "Turn #{n} should be late phase"

      @turn.advance
    end
  end

end
