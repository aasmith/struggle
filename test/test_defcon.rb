require "minitest/autorun"

require "s"

class TestDefcon < MiniTest::Unit::TestCase

  def setup
    @defcon = Defcon.new
  end

  def test_initialize
    assert_equal @defcon.value, 5
  end

  def test_decrease
    @defcon.decrease(USSR, 1)
    assert_equal @defcon.value, 4

    assert_raises ArgumentError do
      @defcon.decrease(USSR, -1)
    end
  end

  def test_increase
    @defcon.decrease(USSR, 2)

    @defcon.increase(USSR, 1)
    assert_equal @defcon.value, 4

    assert_raises ArgumentError do
      @defcon.increase(USSR, -1)
    end
  end

  def test_change
    @defcon.change(USSR, -3)
    assert_equal @defcon.value, 2

    @defcon.change(USSR, 2)
    assert_equal @defcon.value, 4
  end

  def test_set
    @defcon.set(USSR, 3)
    assert_equal @defcon.value, 3

    @defcon.set(USSR, 6)
    assert_equal @defcon.value, 5

    @defcon.set(USSR, 0)
    assert_equal @defcon.value, 1

    assert_raises Defcon::ImmutableDefcon do
      @defcon.set(USSR, 5)
    end
  end

  def test_nuclear_war
    refute @defcon.nuclear_war?

    @defcon.set(USSR, 2)
    refute @defcon.nuclear_war?

    @defcon.decrease(USSR, 1)
    assert @defcon.nuclear_war?

    assert_equal @defcon.destroyed_by, USSR

    # continuing to set DEFCON after DEFCON 1 is a pointless exercise
    assert_raises Defcon::ImmutableDefcon do
      @defcon.decrease(USSR, 1)
    end
  end

  def test_player_present
    assert_raises ArgumentError do
      @defcon.decrease(nil, 1)
    end
  end

end

