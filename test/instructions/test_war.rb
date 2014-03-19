require "helper"

class InstructionTests::WarTest < Struggle::Test

  def test_win
    win = Instructions::War.new(
      player: USSR,
      country_name: "fake",
      victory: true,
      military_ops: 3,
      vp_award: 2
    )

    replace, award, mil_ops = win.execute

    assert_instance_of Instructions::ReplaceInfluence, replace
    assert_instance_of Instructions::AwardVictoryPoints, award
    assert_instance_of Instructions::IncrementMilitaryOps, mil_ops

    assert_equal US,     replace.player
    assert_equal "fake", replace.country_name

    assert_equal USSR, award.player
    assert_equal 2,    award.amount

    assert_equal USSR, mil_ops.player
    assert_equal 3,    mil_ops.amount
  end

  def test_loss
    loss = Instructions::War.new(
      player: US,
      country_name: "fake",
      victory: false,
      military_ops: 2,
      vp_award: 1
    )

    instructions = loss.execute

    assert_equal 1, instructions.size

    mil_ops = instructions.first

    assert_instance_of Instructions::IncrementMilitaryOps, mil_ops

    assert_equal US, mil_ops.player
    assert_equal 2,  mil_ops.amount
  end
end
