module Instructions

  class EarlyPhase < Instruction

    def action
      instructions = []

      3.times do
        instructions << Turn.new(num_cards: 8, num_rounds: 6)
      end

      instructions
    end

  end

end
