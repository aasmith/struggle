module Events
  module CardEvents

    class SadatExpelsSoviets < Instruction

      needs :countries

      def action
        instructions = []

        egypt = countries.find(:egypt)

        instructions << Instructions::RemoveInfluence.new(
             influence: USSR,
          country_name: "Egypt",
                amount: egypt.influence(USSR)
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Egypt",
                amount: 1
        )

        instructions << Instructions::Remove.new(
          card_ref: "SadatExpelsSoviets"
        )

        instructions
      end

    end

  end
end
