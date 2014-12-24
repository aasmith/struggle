module Instructions
  class DegradeDefcon < Instruction

    fancy_accessor :cause

    needs :defcon, :phasing_player

    # A cause (typically an instruction) must be provided for matching.
    # For an example, see Nuclear Subs card event.
    #
    # TODO remove cause and find a better way to screen for defcon
    # degrades that should be ignored (probably higher up the chain)

    def initialize(cause:)
      super

      self.cause = cause
    end

    def action
      defcon.degrade(1)

      instructions = []

      if defcon.one?
        instructions << DeclareWinner.new(
          player: phasing_player.opponent,
          reason: "DEFCON set to 1 by #{phasing_player}"
        )

        instructions << EndGame.new
      end

      instructions
    end
  end
end
