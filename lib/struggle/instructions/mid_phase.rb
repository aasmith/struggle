module Instructions

  class MidPhase < Instruction

    def action
      instructions = []

      instructions << AddToDeck.new(phase: :mid)

      4.times do
        instructions << Turn.new(num_cards: 9, num_rounds: 7)
      end

      instructions
    end

  end

end

