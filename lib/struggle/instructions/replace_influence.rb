module Instructions

  # Replaces all +player+ influence in +country_name+ with
  # opponent influence.

  class ReplaceInfluence < Instruction

    fancy_accessor :player, :country_name

    needs :countries

    def initialize(player:, country_name:)
      super

      self.player = player
      self.country_name = country_name
    end

    def action
      country = countries.find(country_name)
      amount  = country.influence(player)

      if amount.zero?
        log "No %s influence in %s to replace." % [
          player, country_name
        ]

      else

        log "%4s influence in %s replaced with %s influence" % [
          player, country_name, player.opponent
        ]

        instructions = []

        instructions << RemoveInfluence.new(
          country_name: country_name,
          influence: player,
          amount: amount
        )

        instructions << AddInfluence.new(
          country_name: country_name,
          influence: player.opponent,
          amount: amount
        )

        instructions

      end

    end

  end

end
