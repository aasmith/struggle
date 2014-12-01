module Events
  module CardEvents

    class IndoPakistaniWar < Instruction

      needs :phasing_player

      def action
        instructions = []

        instructions << Arbitrators::War.new(
                   player: phasing_player,
            country_names: %w(India Pakistan),
          war_instruction: Instructions::IndoPakistaniWar
        )

        instructions << Instructions::Remove.new(
          card_ref: "IndoPakistaniWar"
        )

        instructions
      end

    end

  end
end
