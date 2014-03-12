module Events
  module CardEvents

    class MarshallPlan < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
          player: US,
          influence: US,
          country_names: non_ussr_controlled_western_europe,
          limit_per_country: 1,
          total_influence: 7
        )

        instructions << Instructions::Remove.new(
          card_ref: "MarshallPlan"
        )

        instructions
      end

      def non_ussr_controlled_western_europe
        countries.
          select { |c| c.in?(WesternEurope) }.
          reject { |c| c.controlled_by?(USSR) }.
          map    { |c| c.name }
      end

    end

  end
end
