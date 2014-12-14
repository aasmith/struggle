module Events
  module CardEvents

    class BrushWar < Instruction

      needs :countries, :phasing_player, :events_in_effect

      def action
        instructions = []

        instructions << Arbitrators::War.new(
                   player: phasing_player,
            country_names: valid_countries.map(&:name),
          war_instruction: Instructions::BrushWar
        )

        instructions << Instructions::Remove.new(
          card_ref: "BrushWar"
        )

        instructions
      end

      def valid_countries
        valid = countries.select { |c| (1..2).include?(c.stability) }

        events_in_effect.include?("Nato") ?
          valid - european_us_controlled :
          valid
      end

      def european_us_controlled
        countries.select do |country|
          country.in?(Europe) && country.controlled_by?(US)
        end
      end

    end

  end
end
