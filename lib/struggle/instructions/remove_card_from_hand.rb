module Instructions
  class RemoveCardFromHand < Instruction
    fancy_accessor :player, :card_ref

    needs :cards, :hands

    def initialize(player:, card_ref:)
      super

      self.player = player
      self.card_ref = card_ref
    end

    def action
      card = cards.find_by_ref(card_ref)

      hands.remove(player, card)
    end
  end
end
