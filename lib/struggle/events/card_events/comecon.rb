module Events
  module CardEvents

    class Comecon < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
          player: USSR,
          influence: USSR,
          country_names: eastern_european_non_us_controlled,
          limit_per_country: 1,
          total_influence: 4
        )

        instructions << Instructions::Remove.new(
          card_ref: "Comecon"
        )

        instructions
      end

      def eastern_european_non_us_controlled
        countries.
          select { |c| c.in?(EasternEurope) && !c.controlled_by?(US) }.
          map    { |c| c.name }
      end

    end

  end
end

