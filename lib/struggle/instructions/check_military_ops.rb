module Instructions
  class CheckMilitaryOps < Instruction
    needs :military_ops, :defcon

    def action
      result = military_ops.calculate_vp(defcon)

      if result.vp > 0
        return AwardVictoryPoints(player: result.player, amount: result.vp)
      end
    end
  end
end
