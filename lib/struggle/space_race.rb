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

  # Advances the superpower one place on the space race.
  #
  # Returns :first or :second depending on whether the superpower is
  # first to reach the new position.

  def advance(superpower)
    return if position(superpower) == MAX_POSITION

    @positions[superpower] += 1

    first_or_second(superpower)
  end

  # Is the given superpower first or second to reach their
  # current position?
  #
  # This only makes sense to ask immediately after an advancement.

  def first_or_second(superpower)
    position(superpower.opponent) < position(superpower) ? :first : :second
  end

  def position(superpower)
    @positions.fetch superpower
  end

  def position_name(player)
    label(position(player))
  end

  def complete?(superpower)
    position(superpower) == MAX_POSITION
  end

  def label(position)
    LABELS.fetch position
  end

  # Returns an EntryRequirement for the next position on the space race
  # for the given player.

  def entry_requirement(superpower)
    return nil if complete? superpower

    entry_requirement_for_position(position(superpower) + 1)
  end

  def entry_requirement_for_position(position)
    ENTRY_REQUIREMENTS.fetch position
  end

  EntryRequirement = Struct.new(:min_ops, :roll_range)

  ENTRY_REQUIREMENTS = {
    1 => EntryRequirement.new(2, 1..3),
    2 => EntryRequirement.new(2, 1..4),
    3 => EntryRequirement.new(2, 1..3),
    4 => EntryRequirement.new(2, 1..4),
    5 => EntryRequirement.new(3, 1..3),
    6 => EntryRequirement.new(3, 1..4),
    7 => EntryRequirement.new(3, 1..3),
    8 => EntryRequirement.new(4, 1..2)
  }

end

