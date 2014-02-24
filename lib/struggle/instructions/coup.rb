module Instructions
  class Coup < Instruction

    fancy_accessor :player, :country_name, :ops_value

    needs :countries, :observers, :die

    def initialize(player:, country_name:)
      super

      self.player = player
      self.country_name = country_name
      self.ops_value = nil
    end

    def action
      instructions = []

      country   = countries.find(country_name)
      stability = country.stability

      roll = die.roll

      mods = observers.die_roll_modifiers(
        player:  player,
        country: country,
        purpose: :coup
      )

      log "Rolls #{roll}"

      roll += mods.map(&:amount).reduce(:+) || 0

      log "Roll is modified to #{roll}"
      log "Ops value is #{ops_value}"

      success = ops_value + roll > stability * 2
      margin  = ops_value + roll - stability * 2

      log "Coup #{success ? "succeeds" : "fails" }"

      if success
        instructions.push(*swing_influence(
          country: country,
          player:  player,
          amount:  margin
        ))
      end

      if country.battleground?
        instructions << Instructions::DegradeDefcon.new(cause: self)
      end

      # award mil ops
      instructions << Instructions::IncrementMilitaryOps.new(
        player: player,
        amount: ops_value
      )

      instructions
    end

    # Returns a list of instructions needed to swing influence in
    # +country+ by +amount+ to the +player+'s favour.
    #
    # Reduces opponent influence by the given amount. If the amount
    # is greater than opponent influence, the excess is used to
    # add the player's own influence to the country.

    def swing_influence(country:, player:, amount:)
      raise ArgumentError, "Influence must be >= 1" unless amount >= 1

      opponent_influence = country.influence(player.opponent)

      unless opponent_influence > 0
        raise ArgumentError, "Opponent #{player.opponent} not in #{country}"
      end

      remove = opponent_influence - amount
      excess = remove < 0 ? remove.abs : 0

      instructions = []

      if excess > 0
        instructions << RemoveInfluence.new(
             influence: player.opponent,
                amount: opponent_influence,
          country_name: country.name
        )

        instructions << AddInfluence.new(
             influence: player,
                amount: excess,
          country_name: country.name
        )

      else
        instructions << RemoveInfluence.new(
             influence: player.opponent,
                amount: amount,
          country_name: country.name
        )

      end

      instructions
    end
  end
end
