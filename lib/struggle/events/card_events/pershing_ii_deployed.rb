module Events
  module CardEvents

    class PershingIiDeployed < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: USSR,
          amount: 1
        )

        instructions << Arbitrators::RemoveInfluence.new(
                     player: USSR,
                  influence: US,
              country_names: western_europe,
          limit_per_country: 1,
            total_influence: 3
        )

        instructions << Instructions::Remove.new(
          card_ref: "PershingIiDeployed"
        )

        instructions
      end

      def western_europe
        countries.
          select { |c| c.in?(WesternEurope) }.
          map    { |c| c.name }
      end

    end

  end
end
