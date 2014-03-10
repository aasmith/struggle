module Events
  module CardEvents

    class PortugueseEmpireCrumbles < Instruction

      def action
        instructions = []

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
          country_name: "SE African States",
                amount: 2
        )

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
          country_name: "Angola",
                amount: 2
        )

        instructions << Instructions::Remove.new(
          card_ref: "PortugueseEmpireCrumbles"
        )

        instructions
      end

    end

  end
end
