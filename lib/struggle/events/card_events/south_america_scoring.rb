module Events
  module CardEvents

    class SouthAmericaScoring < Instruction

      def action
        instructions = []

        instructions << Instructions::ScoreRegion.new(
          region_name: SouthAmerica,
          presence:    2,
          domination:  5,
          control:     6
        )

        instructions << Instructions::Discard.new(
          card_ref: "SouthAmericaScoring"
        )

        instructions
      end

    end

  end
end
