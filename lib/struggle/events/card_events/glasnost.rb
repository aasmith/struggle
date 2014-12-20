module Events
  module CardEvents

    class Glasnost < Instruction

      needs :events_in_effect

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: USSR,
          amount: 2
        )

        instructions << Instructions::ImproveDefcon.new(
          amount: 1
        )

        if events_in_effect.include?("TheReformer")
          log "The Reformer is in effect, USSR gets a free 4 op move"

          instructions << Arbitrators::FreeMove.new(
            player: USSR,
               ops: 4,
              only: %i(influence realignment)
          )
        end

        instructions << Instructions::Remove.new(
          card_ref: "Glasnost"
        )

        instructions
      end

    end

  end
end
