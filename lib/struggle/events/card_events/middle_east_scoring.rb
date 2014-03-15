module Events
  module CardEvents

    class MiddleEastScoring < Instruction

      def action
        instructions = []

        instructions << Instructions::ScoreRegion.new(
          region_name: MiddleEastScoring,
          presence:    3,
          domination:  5,
          control:     7
        )

        instructions << Instructions::Discard.new(
          card_ref: "MiddleEastScoring"
        )

        instructions
      end

    end

  end
end
