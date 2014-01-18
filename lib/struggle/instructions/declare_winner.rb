module Instructions
  class DeclareWinner < Instruction
    arguments :player

    needs :victory

    def action
      victory.winner = player
    end
  end
end
