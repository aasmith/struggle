module Events
  module CardEvents

    class IndependentReds < Instruction

      needs :countries

      COUNTRY_NAMES = %w(Yugoslavia Romania Bulgaria Hungary Czechoslovakia)

      def action
        instructions = []
        choices = []

        COUNTRY_NAMES.each do |name|
          country = countries.find(name)

          amount_needed = country.amount_needed_to_equal(USSR)

          unless amount_needed.zero?
            choices << Arbitrators::AddInfluence.new(
              player: US,
              influence: US,
              country_names: [name],
              total_influence: amount_needed
            )
          end
        end

        # if there is nothing to add in any of these countries, dont even
        # try to solicit input from the player

        if choices.empty?
          log "The US and USSR are either equal, or the USSR is not present " \
              "in all of the countries listed in this event."
          log "Therefore, no influence can be placed by the US for this event"

        else
          instructions << Arbitrators::Proxy.new(
            player: US,
            choices: choices,
            allows_noop: false
          )

        end

        instructions << Instructions::Remove.new(
          card_ref: "IndependentReds"
        )

        instructions
      end

    end

  end
end
