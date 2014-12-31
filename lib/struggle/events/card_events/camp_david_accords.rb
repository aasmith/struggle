module Events
  module CardEvents

    class CampDavidAccords < Instruction

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: 1
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Israel",
                amount: 1
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Jordan",
                amount: 1
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Egypt",
                amount: 1
        )

        instructions << Instructions::PlaceInEffect.new(
          card_ref: "CampDavidAccords"
        )

        instructions << Instructions::Remove.new(
          card_ref: "CampDavidAccords"
        )

        instructions
      end

    end

  end
end
