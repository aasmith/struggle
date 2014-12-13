module Events
  module CardEvents

    class ArabIsraeliWar < Instruction

      include WarResolver

      needs :countries, :die

      def action
        victory = resolve_war(
                  player: USSR,
            country_name: "Israel",
           victory_range: 4..6,
          include_target: true
        )

        instructions = []

        instructions << Instructions::WarOutcomeFactory.build(
                player: USSR,
          country_name: "Israel",
               victory: victory,
          military_ops: 2,
              vp_award: 2
        )

        instructions << Instructions::Discard.new(
          card_ref: "ArabIsraeliWar"
        )

        instructions
      end

    end

  end
end
