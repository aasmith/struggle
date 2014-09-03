module Instructions

  # Handles the aftermath of a war that has been lost.
  #
  # Awards military ops.
  #
  # See WarResolver#resolve_war for determining a war victory or loss.
  # See WarOutcomeFactory#build for generating the correct course of action
  # for handling the post-war aftermath.
  #
  class WarLoss < Instruction

    fancy_accessor :player, :country_name, :military_ops

    def initialize(player:, country_name:, military_ops:)
      super

      self.player = player
      self.country_name = country_name
      self.military_ops = military_ops
    end

    def action
      instructions = []

      log "%4s loses the war in %s." % [player, country_name]

      instructions << IncrementMilitaryOps.new(
          player: player,
          amount: military_ops
      )

      instructions
    end

  end

end
