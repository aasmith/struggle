# Region is a group of countries that can assist with scoring.
class Region

  attr_reader :countries

  def initialize(countries)
    @countries = countries
  end

  def level(superpower)
    return :control    if control?(superpower)
    return :domination if domination?(superpower)
    return :presence   if presence?(superpower)
    return :none
  end

  def control?(superpower)
    # The use of any? forces there to be at least one battleground
    # (as all? returns true for zero battlegrounds)
    battlegrounds.any?   { |c| c.controlled_by?(superpower) } &&
      battlegrounds.all? { |c| c.controlled_by?(superpower) } &&
      most_countries?(superpower)
  end

  def domination?(superpower)
    non_battlegrounds.any? { |c| c.controlled_by?(superpower) } &&
      battlegrounds.any?   { |c| c.controlled_by?(superpower) } &&
      most_countries?(superpower) &&
      most_battlegrounds?(superpower)
  end

  def presence?(superpower)
    countries.any? { |c| c.controlled_by?(superpower) }
  end

  def most_countries?(superpower)
    player_controlled   = controlled_countries(superpower)
    opponent_controlled = controlled_countries(superpower.opponent)

    player_controlled.size > opponent_controlled.size
  end

  def most_battlegrounds?(superpower)
    player_controlled   = controlled_battlegrounds(superpower)
    opponent_controlled = controlled_battlegrounds(superpower.opponent)

    player_controlled.size > opponent_controlled.size
  end

  def controlled_countries(superpower)
    countries.select { |c| c.controlled_by?(superpower) }
  end

  def controlled_battlegrounds(superpower)
    battlegrounds.select { |c| c.controlled_by?(superpower) }
  end

  def battlegrounds
    countries.select { |c| c.battleground? }
  end

  def non_battlegrounds
    countries.reject { |c| c.battleground? }
  end

  def enemy_adjacency(superpower)
    controlled_countries(superpower).select do |country|
      country.adjacent_superpower?(superpower.opponent)
    end
  end

  def score(presence:, domination:, control:)
    scores = { US => 0, USSR => 0 }

    rewards = {
      presence:   presence,
      domination: domination,
      control:    control,
      none:       0
    }

    scores.each_key do |superpower|
      scores[superpower] += rewards[level(superpower)]
      scores[superpower] += controlled_battlegrounds(superpower).size
      scores[superpower] += enemy_adjacency(superpower).size
    end

    winner, winner_score = scores.max_by { |player, score| score }
    _,      loser_score  = scores.min_by { |player, score| score }

    if winner_score != loser_score
      VpReward.new(winner, winner_score - loser_score)
    end
  end

  def controlled?
    controlled_by?(USSR) || controlled_by?(US)
  end

  def controlled_by?(superpower)
    level(superpower) == :control
  end

  VpReward = Struct.new(:player, :amount)

end
