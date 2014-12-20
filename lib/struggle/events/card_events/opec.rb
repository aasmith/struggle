module Events
  module CardEvents

    class Opec < Instruction

      needs :events_in_effect, :countries

      def action
        instructions = []

        if events_in_effect.include?("NorthSeaOil")

          log "North Sea Oil is in effect, OPEC event will not execute"

        else

          vp = 0
          opec_countries = ["Egypt", "Iran", "Libya", "Saudi Arabia",
                            "Iraq", "Gulf States", "Venezuela"]

          opec_countries.each do |country_name|
            country = countries.find(country_name)

            if country.controlled_by?(USSR)
              log "USSR gets 1 Victory Point for control of %s" % [
                country_name
              ]

              vp += 1
            end

          end

          if vp > 0
            instructions << Instructions::AwardVictoryPoints.new(
              player: USSR,
              amount: vp
            )
          end

        end

        instructions << Instructions::Discard.new(
          card_ref: "Opec"
        )

        instructions
      end

    end

  end
end
