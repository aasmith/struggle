module Events
  module CardEvents

    class ArabIsraeliWar < Instruction

      include WarResolver

      needs :countries, :die, :events_in_effect

      def action
        instructions = []

        if events_in_effect.include?("CampDavidAccords")
          log "Event will not execute as Camp David Accords are in effect."

        else

          victory = resolve_war(
                    player: USSR,
              country_name: "Israel",
             victory_range: 4..6,
            include_target: true
          )

          instructions << Instructions::WarOutcomeFactory.build(
                  player: USSR,
            country_name: "Israel",
                 victory: victory,
            military_ops: 2,
                vp_award: 2
          )

        end

        instructions << Instructions::Discard.new(
          card_ref: "ArabIsraeliWar"
        )

        instructions
      end

    end

  end
end
