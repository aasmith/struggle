# Determines the outcome of a war.
#
# Assumes access to die and countries.

module WarResolver

  def resolve_war(player:, country_name:, victory_range:,
                  include_target: false)

    opponent = player.opponent

    country   = countries.find(country_name)
    neighbors = country.neighbors.map { |n| countries.find(n) }

    roll = die.roll

    log "%4s rolls %s" % [player, roll]

    roll -= 1 if include_target && country.controlled_by?(opponent)
    roll -= neighbors.count { |n| n.controlled_by?(opponent) }

    # Don't go below zero
    roll = 0 if roll < 0

    log "Roll is reduced to %s" % roll

    victory_range.include? roll
  end

end

