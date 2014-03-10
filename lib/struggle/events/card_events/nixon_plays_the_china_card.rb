module Events
  module CardEvents

    class NixonPlaysTheChinaCard < Instruction

      needs :china_card

      def action
        instructions = []

        if china_card.holder.us?
          instructions << Instructions::AwardVictoryPoints.new(
            player: US,
            amount: 2
          )
        else
          instructions << Instructions::ClaimChinaCard.new(
            player: US,
            playable: false
          )
        end

        instructions << Instructions::Remove.new(
          card_ref: "NixonPlaysTheChinaCard"
        )

        instructions
      end

    end

  end
end
