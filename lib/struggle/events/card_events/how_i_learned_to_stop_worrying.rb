module Events
  module CardEvents

    class HowILearnedToStopWorrying < Instruction

      needs :phasing_player

      def action
        instructions = []

        instructions << Arbitrators::Basic.new(
          player: phasing_player,
          allows: [
            Instructions::SetDefcon,
            Instructions::Noop
          ]
        )

        instructions << Instructions::IncrementMilitaryOps.new(
          player: phasing_player,
          amount: 5
        )

        instructions << Instructions::Remove.new(
          card_ref: "HowILearnedToStopWorrying"
        )

        instructions
      end

    end

  end
end
