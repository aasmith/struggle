module Events
  module CardEvents

    class SuezCrisis < Instruction

      def action
        instructions = []

        instructions << Arbitrators::RemoveInfluence.new(
          player: USSR,
          influence: US,
          country_names: ["France", "United Kingdom", "Israel"],
          limit_per_country: 2,
          total_influence: 4
        )

        instructions << Instructions::Remove.new(
          card_ref: "SuezCrisis"
        )

        instructions
      end

    end

  end
end
