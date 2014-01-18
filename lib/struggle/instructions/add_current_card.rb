module Instructions
  class AddCurrentCard < Instruction
    arguments :card_ref

    needs :cards, :current_cards

    def action
      card = cards.find_by_ref(card_ref)

      current_cards << card
    end
  end
end
