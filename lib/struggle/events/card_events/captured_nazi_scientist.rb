module Events
  module CardEvents

    class CapturedNaziScientist < Instruction

      needs :phasing_player

      def action
        instructions = []

        instructions << Instructions::AdvanceSpaceRace.new(
          player: phasing_player,
          amount: 1
        )

        instructions << Instructions::Remove.new(
          card_ref: "CapturedNaziScientist"
        )

        instructions
      end

    end

  end
end
