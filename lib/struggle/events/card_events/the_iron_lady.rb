module Events
  module CardEvents

    class TheIronLady < Instruction

      needs :countries

      def action
        instructions = []

        uk = countries.find("United Kingdom")

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: 1
        )

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
          country_name: "Argentina",
                amount: 1
        )

        instructions << Instructions::RemoveInfluence.new(
             influence: USSR,
          country_name: "United Kingdom",
                amount: uk.influence(USSR)
        )

        instructions << Instructions::Remove.new(
          card_ref: "TheIronLady"
        )

        instructions
      end

    end

  end
end
