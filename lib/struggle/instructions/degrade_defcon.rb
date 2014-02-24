module Instructions
  class DegradeDefcon < Instruction

    fancy_accessor :cause

    needs :defcon, :phasing_player

    # A cause (typically an instruction) must be provided for matching.
    # For an example, see Nuclear Subs card event.

    def initialize(cause:)
      self.cause = cause
    end

    def action
      defcon.degrade(phasing_player, 1)
    end
  end
end
