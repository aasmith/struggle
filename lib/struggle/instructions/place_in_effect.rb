module Instructions
  class PlaceInEffect < Instruction

    fancy_accessor :card_ref

    needs :events_in_effect

    def initialize(card_ref:)
      super

      self.card_ref = card_ref
    end

    def action
      events_in_effect.add card_ref
    end

  end
end
