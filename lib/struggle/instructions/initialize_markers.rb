module Instructions

  class InitializeMarkers < Instruction

    needs :turn, :action_round

    def action
      turn.start
      action_round.start

      log "Turn and Action Round markers are set."
    end

  end

end
