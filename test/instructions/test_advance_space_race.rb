require "helper"

class InstructionTests::AdvanceSpaceRaceTest < Struggle::Test

  I = Instructions

  def setup
    @race = SpaceRace.new

    @advance = Instructions::AdvanceSpaceRace.new(
      player: USSR,
      amount: 1
    )

    @jump = Instructions::AdvanceSpaceRace.new(
      player: USSR,
      amount: 3
    )

    @advance.space_race = @race

    @jump.space_race = @race
    @jump.events = FakeEventFinder.new
  end

  def test_advance
    instructions = @advance.action

    advertisement, vp_award = instructions

    assert_equal 2, instructions.size

    assert_instance_of Instructions::SpaceRaceAdvancement, advertisement
    assert_instance_of Instructions::AwardVictoryPoints, vp_award

    assert_equal USSR,   advertisement.player
    assert_equal 1,      advertisement.position
    assert_equal :first, advertisement.first_or_second

    assert_equal USSR, vp_award.player
    assert_equal 2,    vp_award.amount
  end

  def test_second_advancer_gets_lesser_reward
    @race.advance(US) # given the US has already advanced:

    instructions = @advance.action

    advertisement, vp_award = instructions

    assert_equal 2, instructions.size

    assert_instance_of Instructions::SpaceRaceAdvancement, advertisement
    assert_instance_of Instructions::AwardVictoryPoints, vp_award

    assert_equal USSR,    advertisement.player
    assert_equal 1,       advertisement.position
    assert_equal :second, advertisement.first_or_second

    assert_equal USSR, vp_award.player
    assert_equal 1,    vp_award.amount
  end

  def test_multiple_advances_gets_all_events_but_only_last_vp
    instructions = @jump.action

    assert_equal 1, instructions.count { |i| I::AwardVictoryPoints === i }

    vp_award = instructions.last

    assert_equal USSR, vp_award.player
    assert_equal 2,    vp_award.amount

    events = instructions.grep(Instructions::Noop)
    event  = events.first

    assert_equal 1, events.size
    assert_equal "TwoSpaceRacesPerTurn:space", event.label
  end

end
