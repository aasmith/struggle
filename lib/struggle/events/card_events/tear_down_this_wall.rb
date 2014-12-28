module Events
  module CardEvents

    class TearDownThisWall < Instruction

      needs :countries, :observers, :cards, :phasing_player

      def action
        instructions = []

        instructions << Instructions::CancelEffect.new(
          card_ref: "WillyBrandt"
        )

        instructions << Instructions::PlaceInEffect.new(
          card_ref: "TearDownThisWall"
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
                amount: 3,
          country_name: "East Germany"
        )

        card = cards.find_by_ref("TearDownThisWall")
        mods = observers.ops_modifiers_for_player(phasing_player)

        free_coup = Arbitrators::FreeCoup.new(
                 player: US,
            ops_counter: card.ops_counter(mods),
          country_names: europe.map(&:name)
        )

        realignment = Arbitrators::Realignment.new(
                 player: US,
            ops_counter: card.ops_counter(mods),
          country_names: europe.map(&:name)
        )

        instructions << Arbitrators::Proxy.new(
          player: US,
          choices: [free_coup, realignment]
        )

        instructions << Instructions::Remove.new(
          card_ref: "TearDownThisWall"
        )

        instructions
      end

      def europe
        countries.select { |c| c.in?(Europe) }
      end

    end

  end
end
