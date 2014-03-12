module Events
  module CardEvents

    class UssuriRiverSkirmish < Instruction

      needs :countries, :china_card

      def action
        instructions = []

        if china_card.holder.ussr?
          instructions << Instructions::ClaimChinaCard.new(
            player: US,
            playable: true
          )
        else
          instructions << Arbitrators::AddInfluence.new(
                       player: US,
                    influence: US,
                country_names: asia,
            limit_per_country: 2,
              total_influence: 4
          )
        end

        instructions << Instructions::Remove.new(
          card_ref: "UssuriRiverSkirmish"
        )

        instructions
      end

      def asia
        countries.
          select { |c| c.in?(Asia) }.
          map    { |c| c.name }
      end

    end

  end
end
