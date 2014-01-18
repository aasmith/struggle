module Instructions
  class ClaimChinaCard < Instruction
    arguments :player, :playable

    needs :china_card

    def action
      china_card.holder = player
      china_card.playable = playable
    end
  end
end
