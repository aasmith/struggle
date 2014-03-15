module Events
  module CardEvents

    class AsiaScoring < Instruction

      def action
        instructions = []

        instructions << Instructions::ScoreRegion.new(
          region_name: Asia,
          presence:    3,
          domination:  7,
          control:     9
        )

        instructions << Instructions::Discard.new(
          card_ref: "AsiaScoring"
        )

        instructions
      end

    end

  end
end
