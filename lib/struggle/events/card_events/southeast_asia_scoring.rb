module Events
  module CardEvents

    class SoutheastAsiaScoring < Instruction

      needs :countries

      def action
        instructions = []

        country_names = %w(
          Burma Laos/Cambodia Vietnam Malaysia Indonesia Philippines
          Thailand
        )

        vp_awards = Hash.new { |h,k| h[k] = 0 }

        country_names.each do |country_name|
          country = countries.find(country_name)

          amount = country.name == "Thailand" ? 2 : 1

          vp_awards[country.controller] += amount if country.controlled?
        end

        instructions << Instructions::AwardNetVictoryPoints.new(
          players: vp_awards.keys,
          amounts: vp_awards.values
        )

        instructions << Instructions::Remove.new(
          card_ref: "SoutheastAsiaScoring"
        )

        instructions
      end

    end

  end
end
