require "minitest/autorun"

require "s"

class TestVictoryTrack < MiniTest::Unit::TestCase

  def setup
    @vt = VictoryTrack.new
  end

  def test_init_zero
    assert @vt.points.zero?
  end

  def test_add
    @vt.add(US, 2)
    assert_equal @vt.points, -2, "US should be ahead by 2 points"

    @vt.add(USSR, 4)
    assert_equal @vt.points, 2, "USSR should be ahead by 2 points"
  end

  def test_subtract
    @vt.subtract(US, 2)
    assert_equal @vt.points, 2, "USSR should be ahead by 2 points"

    @vt.subtract(USSR, 4)
    assert_equal @vt.points, -2, "US should be ahead by 2 points"
  end

  def test_add_only_positive
    assert_raises(ArgumentError) do
      @vt.add(US, -2)
    end
  end

  def test_subtract_only_positive
    assert_raises(ArgumentError) do
      @vt.subtract(US, -2)
    end
  end

end

