# The space race track stores two pieces of information:
#
#  * How many attempts a player has had (reset each turn)
#  * Where each player is on the track
#
class SpaceRace

  LABELS = {
    0 => "Start",
    1 => "Earth Satellite",
    2 => "Animal in Space",
    3 => "Man in Space",
    4 => "Man in Earth Orbit",
    5 => "Lunar Orbit",
    6 => "Eagle/Bear has Landed",
    7 => "Space Shuttle",
    8 => "Space Station",
  }

  MAX_POSITION = 8

  def initialize
    @positions = { US => 0, USSR => 0 }

    reset_attempts
  end

  def reset_attempts
    @num_attempts = { US => 0, USSR => 0 }
  end

  def attempt(superpower)
    @num_attempts[superpower] += 1
  end

  def attempts(superpower)
    @num_attempts.fetch superpower
  end

  def advance(superpower)
    return if position(superpower) == MAX_POSITION

    @positions[superpower] += 1
  end

  def position(superpower)
    @positions.fetch superpower
  end

  def label(position)
    LABELS.fetch position
  end

end

