module Events
  module CardEvents

    class ReaganBombsLibya < Instruction

      needs :countries

      def action
        instructions = []

        libya = countries.find(:libya)

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: (libya.influence(USSR) / 2.0).floor
        )

        instructions << Instructions::Remove.new(
          card_ref: "ReaganBombsLibya"
        )

        instructions
      end

    end

  end
end
