require "helper"

class MilitaryOpsTest < Struggle::Test

  def test_new
    ops = MilitaryOps.new

    assert_equal 0, ops.value(US)
    assert_equal 0, ops.value(USSR)
  end

  def test_reset
    ops = MilitaryOps.new

    ops.increment(US, 1)
    ops.increment(USSR, 1)

    ops.reset

    assert_equal 0, ops.value(US)
    assert_equal 0, ops.value(USSR)
  end

  def test_military_ops_cannot_exceed_five
    ops = MilitaryOps.new

    ops.increment(US, 4)
    assert_equal 4, ops.value(US)

    ops.increment(US, 3)
    assert_equal 5, ops.value(US), "Ops should max out at five"
  end

  # Test various calculate_vp outcomes

  FakeDefcon = Struct.new(:value)

  def scenario(us:, ussr:, defcon:)
    @ops = MilitaryOps.new
    @ops.increment(US,   us)
    @ops.increment(USSR, ussr)

    @defcon = FakeDefcon.new(defcon)
  end

  def assert_award(player, vp)
    result = @ops.calculate_vp(@defcon)

    assert_equal player, result.player
    assert_equal vp, result.vp
  end

  def assert_no_award
    assert_nil @ops.calculate_vp(@defcon)
  end

  def test_both_players_either_below_or_above_defcon
    scenario us: 2, ussr: 4, defcon: 3
    assert_award USSR, 1
  end

  # Variations of players at a difference of one

  def test_both_players_exceed_defcon
    scenario us: 4, ussr: 5, defcon: 3
    assert_no_award
  end

  def test_both_players_meet_or_exceed_defcon
    scenario us: 3, ussr: 4, defcon: 3
    assert_no_award
  end

  def test_one_player_meets_defcon
    scenario us: 3, ussr: 2, defcon: 3
    assert_award US, 1
  end

  def test_both_players_below_defcon
    scenario us: 1, ussr: 2, defcon: 3
    assert_award USSR, 1
  end

  # Variations of players being level

  def test_both_players_level_and_exceed_defcon
    scenario us: 4, ussr: 4, defcon: 3
    assert_no_award
  end

  def test_both_players_level_and_below_defcon
    scenario us: 2, ussr: 2, defcon: 3
    assert_no_award
  end

  def test_both_players_level_at_defcon
    scenario us: 2, ussr: 2, defcon: 2
    assert_no_award
  end
end
