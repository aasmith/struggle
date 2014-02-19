module Instructions
  class RemoveCurrentCard < Instruction
    fancy_accessor :card_ref

    needs :cards, :current_cards

    def initialize(card_ref:)
      super

      self.card_ref = card_ref
    end

    def action
      card = cards.find_by_ref(card_ref)

      current_cards.delete card
    end
  end
end
