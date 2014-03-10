module Events
  module CardEvents

    class NuclearTestBan < Instruction

      needs :defcon, :phasing_player

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: phasing_player,
          amount: defcon.value - 2
        )

        instructions << Instructions::ImproveDefcon.new(
          amount: 2
        )

        instructions << Instructions::Discard.new(
          card_ref: "NuclearTestBan"
        )

        instructions
      end

    end

  end
end
