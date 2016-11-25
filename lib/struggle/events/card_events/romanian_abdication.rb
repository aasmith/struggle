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

        ussr_influence_for_control = romania.stability - romania.influence(USSR)

        if ussr_influence_for_control > 0

          log "USSR needs %s more points for control of Romania." % [
            ussr_influence_for_control
          ]

          instructions << Instructions::AddInfluence.new(
            influence: USSR,
            country_name: "Romania",
            amount: ussr_influence_for_control
          )
        end

        instructions << Instructions::Remove.new(
          card_ref: "RomanianAbdication"
        )

        instructions
      end

    end

  end
end

