module Events
  module CardEvents

    class OlympicGames < Instruction

      needs :phasing_player

      INPUTS = [
        Instructions::SupportOlympicGames,
        Instructions::BoycottOlympicGames
      ]

      def action
        instructions = []

        # The opponent needs to decide whether to enter the olympics
        # or to boycott them.

        instructions << Arbitrators::Basic.new(
          player: phasing_player.opponent,
          allows: INPUTS
        )

        instructions << Instructions::Discard.new(
          card_ref: "OlympicGames"
        )

        instructions
      end

    end

  end
end
