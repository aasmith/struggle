module Events
  module CardEvents

    class AbmTreaty < Instruction

      needs :phasing_player

      def action
        instructions = []

        instructions << Instructions::ImproveDefcon.new(amount: 1)

        instructions << Arbitrators::FreeMove.new(
          player: phasing_player,
             ops: 4
        )

        instructions << Instructions::Discard.new(
          card_ref: "AbmTreaty"
        )

        instructions
      end

    end

  end
end
