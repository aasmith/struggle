module Instructions

  class ActionRoundsEnd < Instruction

    needs :turn

    def action
      log "All Action Rounds for Turn %s have ended" % turn.number
    end

  end

end
