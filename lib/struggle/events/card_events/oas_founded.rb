module Events
  module CardEvents

    class OasFounded < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
          player: US,
          influence: US,
          country_names: central_and_south_america,
          total_influence: 2
        )

        instructions << Instructions::Remove.new(
          card_ref: "OasFounded"
        )

        instructions
      end

      def central_and_south_america
        countries.
          select { |c| c.in?(CentralAmerica) || c.in?(SouthAmerica) }.
          map    { |c| c.name }
      end

    end

  end
end
