module Events
  module CardEvents

    class IranianHostageCrisis < Instruction

      needs :countries

      def action
        instructions = []

        iran = countries.find(:iran)

        instructions << Instructions::RemoveInfluence.new(
             influence: US,
          country_name: "Iran",
                amount: iran.influence(US)
        )

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
          country_name: "Iran",
                amount: 2
        )

        instructions << Instructions::Remove.new(
          card_ref: "IranianHostageCrisis"
        )

        instructions
      end

    end

  end
end
