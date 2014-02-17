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

  def test_calcuate_vp_favors_us
    ops = MilitaryOps.new

    defcon = FakeDefcon.new(4)

    ops.increment(US, 3)
    ops.increment(USSR, 2)

    result = ops.calculate_vp(defcon)

    assert_equal US, result.player
    assert_equal 1, result.vp
  end

  def test_calcuate_vp_favors_ussr
    ops = MilitaryOps.new

    defcon = FakeDefcon.new(4)

    ops.increment(US, 2)
    ops.increment(USSR, 3)

    result = ops.calculate_vp(defcon)

    assert_equal USSR, result.player
    assert_equal 1, result.vp
  end

  def test_calcuate_vp_draw
    ops = MilitaryOps.new
    ops.increment(US, 1)
    ops.increment(USSR, 1)

    defcon = FakeDefcon.new(4)

    result = ops.calculate_vp(defcon)

    assert_nil result
  end

  def test_calculate_vp_one_player_meets_milops_requirement
    ops = MilitaryOps.new
    ops.increment(US, 5)

    defcon = FakeDefcon.new(2)

    result = ops.calculate_vp(defcon)

    assert_equal US, result.player
    assert_equal 2, result.vp
  end

  FakeDefcon = Struct.new(:value)
end
