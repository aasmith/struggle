require "helper"

class InstructionTests::WarVictoryTest < Struggle::Test

  def test_win
    win = Instructions::WarVictory.new(
        player: USSR,
        country_name: "fake",
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

end