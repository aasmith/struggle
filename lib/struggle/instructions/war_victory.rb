module Instructions

  # Handles the aftermath of a war that has been won.
  #
  # * Awards military ops.
  # * Influence is replaced and VPs awarded.
  #
  # See WarResolver#resolve_war for determining a war victory or loss.
  # See WarOutcomeFactory#build for generating the correct course of action
  # for handling the post-war aftermath.
  #
  class WarVictory < Instruction

    fancy_accessor :player, :country_name, :military_ops, :vp_award

    def initialize(player:, country_name:, military_ops:, vp_award:)
      super

      self.player = player
      self.vp_award = vp_award
      self.country_name = country_name
      self.military_ops = military_ops
    end

    def action
      instructions = []

      log "%4s wins the war in %s." % [player, country_name]

      instructions << ReplaceInfluence.new(
          player: player.opponent,
          country_name: country_name
      )

      instructions << AwardVictoryPoints.new(
          player: player,
          amount: vp_award
      )

      instructions << IncrementMilitaryOps.new(
          player: player,
          amount: military_ops
      )

      instructions
    end

  end

end