module Instructions

  # Handles the outcome of a war.
  #
  # * Awards military ops.
  # * In cases of victory, influence is replaced and VPs awarded.
  #
  # See WarResolver#resolve_war for determining a war victory.
  #
  class WarOutcome < Instruction

    fancy_accessor :player, :country_name, :victory, :military_ops, :vp_award

    def initialize(player:, country_name:, victory:, military_ops:, vp_award:)
      super

      self.player = player
      self.vp_award = vp_award
      self.country_name = country_name
      self.military_ops = military_ops
      self.victory = victory
    end

    def action
      instructions = []

      if victory
        log "%4s wins the war in %s." % [player, country_name]

        instructions << ReplaceInfluence.new(
          player: player.opponent,
          country_name: country_name
        )

        instructions << AwardVictoryPoints.new(
          player: player,
          amount: vp_award
        )

      else
        log "%4s loses the war in %s." % [player, country_name]

      end

      instructions << IncrementMilitaryOps.new(
        player: player,
        amount: military_ops
      )

      instructions
    end

  end

end
