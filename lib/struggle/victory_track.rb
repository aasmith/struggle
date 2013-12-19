require "struggle/superpowers"

class VictoryTrack

  # -20 = USSR victory, +20 = US victory
  attr_reader :points

  def initialize
    @points = 0
  end

  def score
    @points
  end

  def award(player, amount)
    raise ArgumentError, "Cannot award negative VP" if amount < 0

    @points += player.ussr? ? -amount : amount
  end

  def victory?
    victor
  end

  def victor
    return US   if score >= 20
    return USSR if score <= -20
  end
end
