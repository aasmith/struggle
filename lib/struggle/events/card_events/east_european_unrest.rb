module Events
  module CardEvents

    class EastEuropeanUnrest < Instruction

      needs :countries, :turn

      def action
        instructions = []

        instructions << Arbitrators::RemoveInfluence.new(
                     player: US,
                  influence: USSR,
              country_names: eeu,
          limit_per_country: turn.late_phase? ? 2 : 1,
            total_influence: turn.late_phase? ? 6 : 3,
            total_countries: 3
        )

        instructions << Instructions::Discard.new(
          card_ref: "EastEuropeanUnrest"
        )

        instructions
      end

      def eeu
        countries.
          select { |c| c.in?(EasternEurope) }.
          map    { |c| c.name }
      end

    end

  end
end
