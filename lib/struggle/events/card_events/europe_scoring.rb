module Events
  module CardEvents

    class EuropeScoring < Instruction

      def action
        instructions = []

        instructions << Instructions::ScoreRegion.new(
          region_name: Europe,
          presence:    3,
          domination:  7,
          control:     nil
        )

        instructions << Instructions::Discard.new(
          card_ref: "EuropeScoring"
        )

        instructions
      end

    end

  end
end
