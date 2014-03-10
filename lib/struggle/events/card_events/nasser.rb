module Events
  module CardEvents

    class Nasser < Instruction

      needs :countries

      def action
        instructions = []

        egypt = countries.find(:egypt)

        instructions << Instructions::AddInfluence.new(
          influence: USSR,
          country_name: "Egypt",
          amount: 2
        )

        instructions << Instructions::RemoveInfluence.new(
          influence: US,
          country_name: "Egypt",
          amount: half(egypt.influence(US))
        )

        instructions << Instructions::Remove.new(card_ref: "Nasser")

        instructions
      end

      def half(n)
        (n / 2.0).ceil
      end

    end

  end
end
