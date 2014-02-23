module Instructions
  class CheckHeldCards < Instruction
    needs :hands

    def action
      # Order is important here -- if both players are holding scoring cards
      # then USSR loses.

      return winner(US)   if hands.get(USSR).any?(&:scoring?)
      return winner(USSR) if hands.get(US).any?(&:scoring?)
    end

    def winner(player)
      [
        DeclareWinner.new(player: player, reason: "Scoring card held"),
        EndGame.new
      ]
    end
  end
end
