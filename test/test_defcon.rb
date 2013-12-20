require "helper"

class TestDefcon < Struggle::Test

  def test_initialize
    defcon = Defcon.new
    assert_equal 5, defcon.value

    defcon = Defcon.new 3
    assert_equal 3, defcon.value
  end

  def test_degrade
    defcon = Defcon.new
    defcon.degrade(USSR, 1)

    assert_equal 4, defcon.value

    assert_raises ArgumentError, "Should not allow negative values" do
      defcon.degrade(USSR, -1)
    end

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.degrade(USSR, 10)
    end

    assert_equal 4, defcon.value, "Should still be at previous setting"
  end

  def test_improve
    defcon = Defcon.new 3

    defcon.improve(USSR, 1)
    assert_equal 4, defcon.value

    assert_raises ArgumentError, "Should not allow negative values" do
      defcon.improve(USSR, -1)
    end

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.improve(USSR, 10)
    end

    assert_equal 4, defcon.value, "Should still be at previous setting"
  end

  def test_set
    defcon = Defcon.new

    defcon.set(USSR, 3)
    assert_equal 3, defcon.value

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.set(USSR, 6)
    end

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.set(USSR, 0)
    end

    assert_equal 3, defcon.value, "Should still be at previous setting"
  end

  def test_nuclear_war
    defcon = Defcon.new
    refute defcon.nuclear_war?

    defcon.set(USSR, 2)
    refute defcon.nuclear_war?

    defcon.degrade(USSR, 1)
    assert defcon.nuclear_war?

    assert_equal USSR, defcon.destroyed_by

    assert_raises(ImmutableDefcon, "Setting DEFCON after war should fail") do
      defcon.improve(USSR, 2)
    end
  end

  def test_player_present
    defcon = Defcon.new

    assert_raises ArgumentError do
      defcon.degrade(nil, 1)
    end
  end

end

