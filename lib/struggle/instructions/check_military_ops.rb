module Instructions
  class CheckMilitaryOps < Instruction
    needs :military_ops, :defcon

    def action
      result = military_ops.calculate_vp(defcon)

      Instructions::AwardVictoryPoints.new(
        player: result.player,
        amount: result.vp
      ) if result
    end
  end
end
