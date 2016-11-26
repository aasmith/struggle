module Instructions
  class ResetActionRound < Instruction
    needs :action_round

    def action
      action_round.reset
    end
  end
end
