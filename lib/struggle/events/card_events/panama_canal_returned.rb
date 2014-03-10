module Events
  module CardEvents

    class PanamaCanalReturned < Instruction

      def action
        instructions = []

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Panama",
                amount: 1
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Costa Rica",
                amount: 1
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Venezuela",
                amount: 1
        )

        instructions << Instructions::Remove.new(
          card_ref: "PanamaCanalReturned"
        )

        instructions
      end

    end

  end
end
