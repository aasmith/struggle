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
      defcon.degrade(player, 1)

      instructions = []

      if defcon.one?
        instructions << DeclareWinner.new(
          player: player.opponent,
          reason: "DEFCON set to 1 by #{player}"
        )

        instructions << EndGame.new
      end

      instructions
    end

    def player
      phasing_player.player
    end
  end
end
