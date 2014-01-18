module Instructions
  class FlipChinaCard < Instruction
    needs :china_card

    def action
      china_card.flip_up
    end
  end
end
