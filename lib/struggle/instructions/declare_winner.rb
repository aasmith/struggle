module Instructions
  class DeclareWinner < Instruction
    fancy_accessor :player, :reason

    needs :victory

    def initialize(player:, reason:)
      super

      self.player = player
      self.reason = reason
    end

    def action
      victory.winner = player
      victory.reason = reason
    end
  end
end
