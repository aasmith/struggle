module Events
  module CardEvents

    class Decolonization < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
          player: USSR,
          influence: USSR,
          limit_per_country: 1,
          country_names: africa_and_seasia,
          total_influence: 4
        )

        instructions << Instructions::Discard.new(card_ref: "Decolonization")

        instructions
      end

      def africa_and_seasia
        countries.
          select { |c| c.in?(Africa) || c.in?(SoutheastAsia) }.
          map    { |c| c.name }
      end
    end

  end
end
