require "helper"

class InstructionTests::TestAwardNetVictoryPoints < Struggle::Test

  def test_no_award_when_net_zero
    instruction = Instructions::AwardNetVictoryPoints.new(
      players: [USSR, US],
      amounts: [1, 1]
    )

    assert_empty instruction.execute
  end

  def test_ussr_award_when_net_ussr_gain
    instruction = Instructions::AwardNetVictoryPoints.new(
      players: [USSR, US],
      amounts: [2, 1]
    )

    instruction, *other = instruction.execute

    assert_instance_of Instructions::AwardVictoryPoints, instruction
    assert_equal 1,    instruction.amount
    assert_equal USSR, instruction.player

    assert_empty other, "Should be only one instruction"
  end

  def test_us_award_when_net_us_gain
    instruction = Instructions::AwardNetVictoryPoints.new(
      players: [USSR, US],
      amounts: [1, 2]
    )

    instruction, *other = instruction.execute

    assert_instance_of Instructions::AwardVictoryPoints, instruction
    assert_equal 1,  instruction.amount
    assert_equal US, instruction.player

    assert_empty other, "Should be only one instruction"
  end

  def test_negative_values_are_invalid
    assert_raises ArgumentError do
      Instructions::AwardNetVictoryPoints.new(
        players: [USSR, US],
        amounts: [-1, 1]
      )
    end
  end

end
