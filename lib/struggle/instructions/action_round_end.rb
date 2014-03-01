module Instructions
  class ActionRoundEnd < Instruction

    fancy_accessor :number

    def initialize(number:)
      super

      self.number = number
    end

    def action
      log "End of Action Round %s" % number
    end
  end
end
