module Events
  module CardEvents

    class Fidel < Instruction

      needs :countries

      def action
        instructions = []

        cuba = countries.find("Cuba")

        instructions << Instructions::RemoveInfluence.new(
          influence: US,
          country_name: "Cuba",
          amount: cuba.influence(US)
        )

        instructions << Instructions::AddInfluence.new(
          influence: USSR,
          country_name: "Cuba",
          amount: cuba.stability
        )

        instructions << Instructions::Remove.new(
          card_ref: "Fidel"
        )

        instructions
      end

    end

  end
end
