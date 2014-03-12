module Events
  module CardEvents

    class LiberationTheology < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
          player: USSR,
          influence: USSR,
          country_names: central_america,
          limit_per_country: 2,
          total_influence: 3
        )

        instructions << Instructions::Remove.new(
          card_ref: "LiberationTheology"
        )

        instructions
      end

      def central_america
        countries.
          select { |c| c.in?(CentralAmerica) }.
          map    { |c| c.name }
      end

    end

  end
end
