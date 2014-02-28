require "helper"

class SpaceRaceTest < Struggle::Test

  def setup
    @race = SpaceRace.new

    @equal_race = SpaceRace.new
    @equal_race.attempt(US)
    @equal_race.advance(US)
    @equal_race.attempt(USSR)
    @equal_race.advance(USSR)

  end

  def test_space_race_starts_at_zero
    assert_equal 0, @race.attempts(US)
    assert_equal 0, @race.attempts(USSR)

    assert_equal 0, @race.position(US)
    assert_equal 0, @race.position(USSR)
  end

  def test_reset_attempts
    @equal_race.reset_attempts

    assert_equal 0, @equal_race.attempts(US), "Attempts should reset"
    assert_equal 0, @equal_race.attempts(USSR), "Attempts should reset"

    assert_equal 1, @equal_race.position(US), "Position should not change"
    assert_equal 1, @equal_race.position(USSR), "Position should not change"
  end

  def test_attempt
    @race.attempt(US)

    assert_equal 1, @race.attempts(US)
    assert_equal 0, @race.attempts(USSR)

    assert_equal 0, @race.position(US), "Attempts do not increase position"
    assert_equal 0, @race.position(USSR), "Attempts do not increase position"
  end

  def test_advance
    @race.advance(US)

    assert_equal 0, @race.attempts(US), "Advances do not increase attempts"
    assert_equal 0, @race.attempts(USSR), "Advances do not increase attempts"

    assert_equal 1, @race.position(US)
    assert_equal 0, @race.position(USSR)
  end

  def test_advance_caps_at_max
    10.times { @race.advance(US) }

    assert_equal SpaceRace::MAX_POSITION, @race.position(US)
  end

  def test_first_player_to_reach_position
    assert_equal :first, @race.advance(US)
  end

  def test_second_player_to_reach_position
    @race.advance(US)

    assert_equal :second, @race.advance(USSR)
  end

  def test_complete
    7.times do |i|
      @race.advance(USSR)
      @race.advance(US)

      refute @race.complete?(USSR)
      refute @race.complete?(US)
    end

    @race.advance(USSR)

    assert @race.complete?(USSR)
    refute @race.complete?(US)
  end

  def test_entry_requirement_gives_requirements_for_next_position
    @race.advance(US)

    8.times do
      behind = @race.entry_requirement(USSR)
      ahead  = @race.entry_requirement_for_position(@race.position(US))

      assert_equal ahead, behind

      @race.advance(US)
      @race.advance(USSR)
    end
  end

end
