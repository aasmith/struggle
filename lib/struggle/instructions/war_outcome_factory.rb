module Instructions

  # Decides whether to return a WarLoss or WarVictory instruction.
  class WarOutcomeFactory

    def initialize
      raise ArgumentError, "WarOutcomeFactory cannot be initialized"
    end

    class << self

      def build(player:, country_name:, victory:, military_ops:, vp_award:)

        if victory
          WarVictory.new(
            player: player,
            country_name: country_name,
            military_ops: military_ops,
            vp_award: vp_award
          )
        else
          WarLoss.new(
            player: player,
            country_name: country_name,
            military_ops: military_ops
          )
        end

      end

    end

  end

end
