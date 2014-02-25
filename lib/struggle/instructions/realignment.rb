module Instructions
  class Realignment < Instruction

    fancy_accessor :player, :country_name

    needs :countries, :observers, :die

    def initialize(player:, country_name:)
      super

      self.player = player
      self.country_name = country_name
    end

    def action
      opponent = player.opponent
      country  = countries.find(country_name)

      player_bonuses   = bonuses(player, country)
      opponent_bonuses = bonuses(opponent, country)

      player_dmods = observers.die_roll_modifiers(
         player: player,
        country: country,
        purpose: :realignment
      )

      opponent_dmods = observers.die_roll_modifiers(
         player: opponent,
        country: country,
        purpose: :realignment
      )

      player_dmod_sum   = player_dmods.  map(&:amount).reduce(:+) || 0
      opponent_dmod_sum = opponent_dmods.map(&:amount).reduce(:+) || 0

      player_base   = die.roll
      opponent_base = die.roll

      player_roll   = player_base   +   player_dmod_sum +   player_bonuses
      opponent_roll = opponent_base + opponent_dmod_sum + opponent_bonuses

      roll_info_msg = "%4s rolls %s. Becomes %s after modifiers and bonuses"

      log roll_info_msg % [ player,   player_base,   player_roll ]
      log roll_info_msg % [ opponent, opponent_base, opponent_roll ]

      if player_roll == opponent_roll
        log "Rolls tied. No influence is removed."

      else

        high_roller = player_roll > opponent_roll ? player : opponent
        low_roller  = high_roller.opponent

        difference = (player_roll - opponent_roll).abs

        log "%s is the high roller." % [high_roller]

        log "%s to remove %s %s influence from %s" % [
          high_roller, difference, low_roller, country.name
        ]

        opponent_influence = country.influence(low_roller)

        if opponent_influence.zero?
          log "%s has no influence in %s." % [
            low_roller, country.name
          ]

        elsif difference > opponent_influence
          log "%s only has %s influence in %s, removing all influence." % [
            low_roller, opponent_influence, country.name
          ]

          Instructions::RemoveInfluence.new(
               influence: low_roller,
                  amount: opponent_influence,
            country_name: country.name
          )

        else
          Instructions::RemoveInfluence.new(
               influence: low_roller,
                  amount: difference,
            country_name: country.name
          )
        end

      end

    end

    # What bonuses does this player get for a realignment attempt in
    # this country?
    #
    # +1 for more influence in country
    # +1 for superpower adjacency
    # +1 for each adjacent controlled country

    def bonuses(player, country)
      bonus = 0

      if country.influence(player) > country.influence(player.opponent)
        log "%4s gets +1 bonus for more influence" % player
        bonus += 1
      end

      if country.adjacent_superpower?(player)
        log "%4s gets +1 bonus for own superpower adjacency" % player
        bonus += 1
      end

      neighbors = country.neighbors.map { |name| countries.find(name) }
      ncount    = neighbors.count { |n| n.controlled_by?(player) }

      if ncount > 0
        log "%4s gets +%s for control of %s neighbors" % [
          player, ncount, ncount
        ]

        bonus += ncount
      end

      if bonus.zero?
        log "%4s gets no realignment bonuses." % player
      end

      bonus
    end

  end
end
