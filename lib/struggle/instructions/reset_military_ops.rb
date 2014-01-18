module Instructions
  class ResetMilitaryOps < Instruction
    needs :military_ops

    def action
      military_ops.reset
    end
  end
end
