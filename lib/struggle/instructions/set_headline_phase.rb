module Instructions
  class SetHeadlinePhase < Instruction
    fancy_accessor :active

    needs :headline_phase

    def initialize(active:)
      super

      self.active = active
    end

    def action
      log "Headline Phase has %s." % [active ? "begun" : "ended"]

      headline_phase.active = active
    end

    def needs_raw?
      true
    end
  end
end
