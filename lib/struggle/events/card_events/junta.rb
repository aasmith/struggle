module Events
  module CardEvents

    class Junta < Instruction

      needs :countries, :observers, :cards, :phasing_player

      def action
        instructions = []

        instructions << Arbitrators::AddInfluence.new(
                   player: phasing_player,
                influence: phasing_player,
            country_names: south_or_central_america.map(&:name),
          total_influence: 2,
          total_countries: 1
        )

        card = cards.find_by_ref("Junta")
        mods = observers.ops_modifiers_for_player(phasing_player)

        free_coup = Arbitrators::FreeCoup.new(
                 player: phasing_player,
            ops_counter: card.ops_counter(mods),
          country_names: south_or_central_america.map(&:name)
        )

        realignment = Arbitrators::Realignment.new(
                 player: phasing_player,
            ops_counter: card.ops_counter(mods),
          country_names: south_or_central_america.map(&:name)
        )

        instructions << Arbitrators::Proxy.new(
           player: phasing_player,
          choices: [free_coup, realignment]
        )

        instructions << Instructions::Discard.new(
          card_ref: "Junta"
        )

        instructions
      end

      def south_or_central_america
        countries.select { |c| c.in?(CentralAmerica) || c.in?(SouthAmerica) }
      end

    end

  end
end
