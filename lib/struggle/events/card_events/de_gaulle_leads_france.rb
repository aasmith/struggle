module Events
  module CardEvents

    class DeGaulleLeadsFrance < Instruction

      def action
        instructions = []

        instructions << Instructions::RemoveInfluence.new(
             influence: US,
          country_name: "France",
                amount: 2
        )

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
          country_name: "France",
                amount: 1
        )

        instructions << Instructions::PlaceInEffect.new(
          card_ref: "DeGaulleLeadsFrance"
        )

        instructions << Instructions::Remove.new(
          card_ref: "DeGaulleLeadsFrance"
        )

        instructions
      end

    end

  end
end
