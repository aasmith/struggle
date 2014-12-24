module Arbitrators

  # A Basic arbitrator only allows a single move from the list
  # specified in the +allows+ parameter.

  class Basic < MoveArbitrator

    fancy_accessor :player, :allows

    def initialize(player:, allows:)
      super

      self.player = player
      self.allows = allows
    end

    def after_execute(move)
      complete
    end

    def accepts?(move)
      allowed_move?(move) && correct_player?(move)
    end

    def allowed_move?(move)
      allows.include? move.instruction.class
    end

  end
end
