module Events
  module CardEvents

    class OlympicGames < Instruction

      needs :phasing_player

      def action
        instructions = []

        # The opponent needs to decide whether to enter the olympics
        # or to boycott them.

        instructions << Arbitrators::OlympicGames.new(
          player: phasing_player.opponent
        )

        instructions << Instructions::Discard.new(
          card_ref: "OlympicGames"
        )

        instructions
      end

    end

  end
end
