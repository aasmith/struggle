module Events
  module CardEvents

    class OrtegaElectedInNicaragua < Instruction

      needs :countries, :observers, :cards, :phasing_player

      def action
        instructions = []

        nicaragua = countries.find("Nicaragua")

        instructions << Instructions::RemoveInfluence.new(
             influence: US,
                amount: nicaragua.influence(US),
          country_name: "Nicaragua"
        )

        card = cards.find_by_ref("OrtegaElectedInNicaragua")
        mods = observers.ops_modifiers_for_player(phasing_player)

        free_coup = Arbitrators::FreeCoup.new(
                 player: USSR,
            ops_counter: card.ops_counter(mods),
          country_names: "Nicaragua"
        )

        # Allows either a free coup or a noop.
        instructions << Arbitrators::Proxy.new(
           player: US,
          choices: [free_coup]
        )

        instructions << Instructions::Remove.new(
          card_ref: "OrtegaElectedInNicaragua"
        )

        instructions
      end

    end

  end
end
