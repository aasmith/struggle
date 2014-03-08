module Events
  module CardEvents

    class RomanianAbdication < Instruction

      needs :countries

      def action
        instructions = []

        romania = countries.find("Romania")

        instructions << Instructions::RemoveInfluence.new(
          influence: US,
          country_name: "Romania",
          amount: romania.influence(US)
        )

        instructions << Instructions::AddInfluence.new(
          influence: USSR,
          country_name: "Romania",
          amount: romania.stability
        )

        instructions << Instructions::Remove.new(
          card_ref: "RomanianAbdication"
        )

        instructions
      end

    end

  end
end

