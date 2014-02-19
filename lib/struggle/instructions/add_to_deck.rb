module Instructions
  class AddToDeck < Instruction
    fancy_accessor :phase

    needs :cards, :deck

    def initialize(phase:)
      super

      self.phase = phase
    end

    def action
      deck.add(cards.select { |c| c.phase == phase && !c.china_card? })
    end
  end
end
