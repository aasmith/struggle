module Events
  module CardEvents

    class SovietsShootDownKal007 < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Instructions::DegradeDefcon.new(
          cause: self
        )

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: 2
        )

        south_korea = countries.find("South Korea")

        if south_korea.controlled_by?(US)
          log "South Korea is US controlled"
          log "US gets a free 4 ops move for influence or realignment"

          instructions << Arbitrators::FreeMove.new(
            player: US,
               ops: 4,
              only: %i(influence realignment)
          )
        end

        instructions << Instructions::Remove.new(
          card_ref: "SovietsShootDownKal007"
        )

        instructions
      end

    end

  end
end

