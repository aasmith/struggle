##
# Removes cards from +current_cards+, discarding if needed.
#
# In the case of the China Card, it is handed to the opponent.
#
module Instructions
  class DisposeCurrentCards < Instruction
    needs :current_cards

    def action
      instructions = []

      current_cards.each do |card|
        remove_from_current_cards = Instructions::RemoveCurrentCard.new(
          card_ref: card.ref
        )

        discard_or_surrender = card.china_card? ?
          Instructions::SurrenderChinaCard.new :
          Instructions::Discard.new(card_ref: card.ref)

        instructions.push remove_from_current_cards, discard_or_surrender
      end

      instructions
    end
  end
end
