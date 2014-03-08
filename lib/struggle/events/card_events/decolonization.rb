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
          countries: africa_and_seasia,
          total_influence: 4
        )

        instructions << Discard.new(card_ref: "Decolonization")

        instructions
      end

      def africa_and_seasia
        countries.select { |c| c.in?(Africa) || c.in?(SoutheastAsia) }
      end
    end

  end
end
