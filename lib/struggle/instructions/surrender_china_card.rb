module Instructions
  class SurrenderChinaCard < Instruction
    needs :china_card

    def action
      china_card.holder = china_card.holder.opponent
      china_card.playable = false
    end
  end
end
