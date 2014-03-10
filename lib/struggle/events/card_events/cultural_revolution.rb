module Events
  module CardEvents

    class CulturalRevolution < Instruction

      needs :china_card

      def action
        instructions = []

        if china_card.holder.us?
          instructions << Instructions::ClaimChinaCard.new(
            player: USSR,
            playable: true
          )
        else
          instructions << Instructions::AwardVictoryPoints.new(
            player: USSR,
            amount: 1
          )
        end

        instructions << Instructions::Remove.new(
          card_ref: "CulturalRevolution"
        )

        instructions
      end

    end

  end
end
