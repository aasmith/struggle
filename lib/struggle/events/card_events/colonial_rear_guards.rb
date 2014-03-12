module Events
  module CardEvents

    class ColonialRearGuards < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
          player: US,
          influence: US,
          country_names: africa_and_southeast_asia,
          limit_per_country: 1,
          total_influence: 4
        )

        instructions << Instructions::Discard.new(
          card_ref: "ColonialRearGuards"
        )

        instructions
      end

      def africa_and_southeast_asia
        countries.
          select { |c| c.in?(Africa) || c.in?(SoutheastAsia) }.
          map    { |c| c.name }
      end

    end

  end
end
