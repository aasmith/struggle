module Instructions
  class DeclareWinner < Instruction
    fancy_accessor :player

    needs :victory

    def initialize(player:)
      super

      self.player = player
    end

    def action
      victory.winner = player
    end
  end
end
