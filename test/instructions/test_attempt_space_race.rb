require "helper"

class InstructionTests::AttemptSpaceRaceTest < Struggle::Test

  def setup
    @attempt = Instructions::AttemptSpaceRace.new(
      player: USSR,
      card_ref: "SomeCard"
    )

    @race = SpaceRace.new

    @attempt.space_race = @race
  end

  def test_successful_roll_advances_space_race
    @attempt.die = OneSidedDie.new(2)

    instructions = @attempt.action

    discard, advance = instructions

    assert_equal 1, @race.attempts(USSR)
    assert_equal 2, instructions.size

    assert_instance_of Instructions::Discard, discard
    assert_instance_of Instructions::AdvanceSpaceRace, advance

    assert_equal "SomeCard", discard.card_ref

    assert_equal USSR, advance.player
    assert_equal 1, advance.amount
  end

  def test_fateful_roll_doesnt_advance_space_race
    @attempt.die = OneSidedDie.new(5)

    instructions = @attempt.action

    discard, _ = instructions

    assert_equal 1, @race.attempts(USSR)
    assert_equal 1, instructions.size

    assert_instance_of Instructions::Discard, discard

    assert_equal "SomeCard", discard.card_ref
  end
end
