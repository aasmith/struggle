module Instructions

  class AwardChinaCardHolder < Instruction

    needs :china_card

    def action
      instructions = []

      instructions << AwardVictoryPoints.new(
        player: china_card.holder,
        amount: 1
      )

      instructions
    end

  end

end
