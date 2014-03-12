module Events
  module CardEvents

    class TheVoiceOfAmerica < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Arbitrators::RemoveInfluence.new(
          player: US,
          influence: USSR,
          country_names: not_europe,
          limit_per_country: 2,
          total_influence: 4
        )

        instructions << Instructions::Remove.new(
          card_ref: "TheVoiceOfAmerica"
        )

        instructions
      end

      def not_europe
        countries.
          reject { |c| c.in?(Europe) }.
          map    { |c| c.name }
      end

    end

  end
end
