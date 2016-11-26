module Instructions
  class ActionRoundEnd < Instruction

    fancy_accessor :number

    needs :action_round

    def initialize(number:)
      super

      self.number = number
    end

    def action
      action_round.advance

      log "End of Action Round %s" % number
    end
  end
end
