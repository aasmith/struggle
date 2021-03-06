module Events
  module CardEvents

    class AnEvilEmpire < Instruction

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: 1
        )

        instructions << Instructions::CancelEffect.new(
          card_ref: "FlowerPower"
        )

        instructions << Instructions::PreventPlayOfEvent.new(
          card_ref: "FlowerPower",
            reason: "An Evil Empire is in effect."
        )

        instructions << Instructions::PlaceInEffect.new(
          card_ref: "AnEvilEmpire"
        )

        instructions << Instructions::Remove.new(
          card_ref: "AnEvilEmpire"
        )

        instructions
      end

    end

  end
end
