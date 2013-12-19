require "minitest/autorun"

require "struggle"

class TestVictoryTrack < Minitest::Test

  def setup
    @vt = VictoryTrack.new
  end

  def test_init_zero
    assert @vt.points.zero?
  end

  def test_award
    @vt.award(US, 5)
    assert_equal(5, @vt.score)

    @vt.award(USSR, 10)
    assert_equal(-5, @vt.score)
  end

  def test_negative_award
    assert_raises(ArgumentError) do
      @vt.award(US, -1)
    end

    assert_raises(ArgumentError) do
      @vt.award(USSR, -1)
    end
  end

  def test_victory_for_us
    @vt.award(US, 19)
    refute @vt.victor, "No one should win at 19 VP"
    refute @vt.victory?

    @vt.award(US, 1)
    assert_equal US, @vt.victor, "US should win at 20 VP"
    assert @vt.victory?

    @vt.award(US, 1)
    assert_equal US, @vt.victor, "US should win at >20 VP"
    assert @vt.victory?
  end

  def test_victory_for_ussr
    @vt.award(USSR, 19)
    refute @vt.victor, "No one should win at 19 VP"
    refute @vt.victory?

    @vt.award(USSR, 1)
    assert_equal USSR, @vt.victor, "USSR should win at -20 VP"
    assert @vt.victory?

    @vt.award(USSR, 1)
    assert_equal USSR, @vt.victor, "USSR should win at <20 VP"
    assert @vt.victory?
  end
end

