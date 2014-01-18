module Instructions
  class AdvanceTurn < Instruction
    needs :turn

    def action
      turn.advance
    end
  end
end
