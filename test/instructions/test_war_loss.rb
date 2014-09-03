require "helper"

class InstructionTests::WarLossTest < Struggle::Test

  def test_loss
    loss = Instructions::WarLoss.new(
        player: US,
        country_name: "fake",
        military_ops: 2
    )

    instructions = loss.execute

    assert_equal 1, instructions.size

    mil_ops = instructions.first

    assert_instance_of Instructions::IncrementMilitaryOps, mil_ops

    assert_equal US, mil_ops.player
    assert_equal 2,  mil_ops.amount
  end

end