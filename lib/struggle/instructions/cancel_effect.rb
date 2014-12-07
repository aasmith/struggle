module Instructions
  class CancelEffect < Instruction

    fancy_accessor :card_ref

    needs :events_in_effect

    def initialize(card_ref:)
      super

      self.card_ref = card_ref
    end

    def action
      events_in_effect.remove card_ref
    end

  end
end

