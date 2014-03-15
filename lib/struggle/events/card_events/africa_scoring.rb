module Events
  module CardEvents

    class AfricaScoring < Instruction

      def action
        instructions = []

        instructions << Instructions::ScoreRegion.new(
          region_name: Africa,
          presence:    1,
          domination:  4,
          control:     6
        )

        instructions << Instructions::Discard.new(
          card_ref: "AfricaScoring"
        )

        instructions
      end

    end

  end
end
