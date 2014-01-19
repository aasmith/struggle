module Instructions
  class RemoveCardFromHand < Instruction
    arguments :player, :card_ref

    needs :cards, :hands

    def action
      card = cards.find_by_ref(card_ref)

      hands.remove(player, card)
    end
  end
end
