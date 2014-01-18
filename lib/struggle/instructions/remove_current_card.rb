module Instructions
  class RemoveCurrentCard < Instruction
    arguments :card_ref

    needs :cards, :current_cards

    def action
      card = cards.find_by_ref(card_ref)

      current_cards.delete card
    end
  end
end
