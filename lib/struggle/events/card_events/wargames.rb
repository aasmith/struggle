module Events
  module CardEvents

    class Wargames < Instruction

      needs :defcon, :phasing_player

      INPUTS = [
        Instructions::WargamesAwardVpAndEndGame,
        Instructions::WargamesAwardVp,
        Instructions::Noop
      ]

      def action
        instructions = []

        if defcon.value == 2
          log "DEFCON is at 2, %s to decide Wargames outcome." %  [
            phasing_player
          ]

          instructions << Arbitrators::Basic.new(
             player: phasing_player,
             allows: INPUTS
          )

          instructions << Instructions::Remove.new(
            card_ref: "Wargames"
          )

        else
          log "Wargames requires DEFCON 2."
          log "DEFCON is at %s, so the event will not be executed." % [
            defcon.value
          ]

          instructions << Instructions::Discard.new(
            card_ref: "Wargames"
          )
        end

        instructions
      end

    end

  end
end
