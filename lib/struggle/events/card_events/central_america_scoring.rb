module Events
  module CardEvents

    class CentralAmericaScoring < Instruction

      def action
        instructions = []

        instructions << Instructions::ScoreRegion.new(
          region_name: CentralAmerica,
          presence:    1,
          domination:  3,
          control:     5
        )

        instructions << Instructions::Discard.new(
          card_ref: "CentralAmericaScoring"
        )

        instructions
      end

    end

  end
end
