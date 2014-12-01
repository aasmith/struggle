module Events
  module CardEvents

    class IranIraqWar < Instruction

      needs :phasing_player

      def action
        instructions = []

        instructions << Arbitrators::War.new(
                   player: phasing_player,
            country_names: %w(Iran Iraq),
          war_instruction: Instructions::IranIraqWar
        )

        instructions << Instructions::Remove.new(
          card_ref: "IranIraqWar"
        )

        instructions
      end

    end

  end
end
