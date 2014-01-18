module Instructions
  class AddToDeck < Instruction
    arguments :phase

    needs :cards, :deck

    def action
      deck.add(cards.select { |c| c.phase == phase && !c.china_card? })
    end
  end
end
