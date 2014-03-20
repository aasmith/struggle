module Events
  module CardEvents

    class KoreanWar < Instruction

      include WarResolver

      needs :countries, :die

      def action
        victory = resolve_war(
          player: USSR, country_name: "South Korea", victory_range: 4..6
        )

        instructions = []

        instructions << Instructions::War.new(
          player: USSR,
          country_name: "South Korea",
          victory: victory,
          military_ops: 2,
          vp_award: 2
        )

        instructions << Instructions::Discard.new(
          card_ref: "KoreanWar"
        )

        instructions
      end

    end

  end
end
