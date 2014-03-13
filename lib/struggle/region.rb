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
    return nil
  end

  def control?(superpower)
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
    ours   = countries.count { |c| c.controlled_by?(superpower) }
    theirs = countries.count { |c| c.controlled_by?(superpower.opponent) }

    ours > theirs
  end

  def most_battlegrounds?(superpower)
    ours   = battlegrounds.count { |c| c.controlled_by?(superpower) }
    theirs = battlegrounds.count { |c| c.controlled_by?(superpower.opponent) }

    ours > theirs
  end

  def battlegrounds
    countries.select { |c| c.battleground? }
  end

  def non_battlegrounds
    countries.reject { |c| c.battleground? }
  end

end
