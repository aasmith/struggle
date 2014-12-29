module Events
  module CardEvents

    class PuppetGovernments < Instruction

      needs :countries

      def action
        instructions = []

        place_influence = Arbitrators::AddInfluence.new(
                     player: US,
                  influence: US,
              country_names: no_influence.map(&:name),
            total_influence: 3,
          limit_per_country: 1
        )

        # As this event is optional, we use a proxy so the player can opt out
        # by playing a Noop.

        instructions << Arbitrators::Proxy.new(
           player: US,
          choices: [place_influence]
        )

        instructions << Instructions::Discard.new(
          card_ref: "PuppetGovernments"
        )

        instructions
      end

      def no_influence
        countries.select { |c| c.empty? }
      end

    end

  end
end
