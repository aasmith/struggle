module Events
  module CardEvents

    class Allende < Instruction

      def action
        instructions = []

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
          country_name: "Chile",
                amount: 2
        )

        instructions << Instructions::Remove.new(card_ref: "Allende")

        instructions
      end

    end

  end
end
