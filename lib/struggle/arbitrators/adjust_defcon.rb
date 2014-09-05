module Arbitrators

  # Allows the given player to optionally improve or degrade DEFCON.
  # Accepts a Noop to pass on changing DEFCON.

  class AdjustDefcon < MoveArbitrator

    fancy_accessor :player

    def initialize(player:)
      super

      self.player = player
    end

    def accepts?(move)
      defcon_move?(move) && correct_player?(move) && valid_amount?(move)
    end

    def defcon_move?(move)
      VALID_INSTRUCTIONS.include?(move.instruction.class)
    end

    def valid_amount?(move)
      instruction = move.instruction

      instruction.respond_to?(:amount) ? instruction.amount == 1 : true
    end

    VALID_INSTRUCTIONS = [
      Instructions::ImproveDefcon,
      Instructions::DegradeDefcon,
      Instructions::Noop
    ]

  end
end
