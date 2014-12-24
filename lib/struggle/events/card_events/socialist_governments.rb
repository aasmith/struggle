module Events
  module CardEvents

    class SocialistGovernments < Instruction

      needs :countries, :events_in_effect

      def action
        instructions = []

        if events_in_effect.include?("TheIronLady")
          log "The Iron Lady is in effect."
          log "Socialist Governments event will not be triggered."

        else

          instructions << Arbitrators::RemoveInfluence.new(
                       player: USSR,
                    influence: US,
                country_names: western_europe.map(&:name),
              total_influence: 3,
            limit_per_country: 2
          )

        end

        instructions << Instructions::Discard.new(
          card_ref: "SocialistGovernments"
        )

        instructions
      end

      def western_europe
        countries.select { |c| c.in?(WesternEurope) }
      end

    end

  end
end
