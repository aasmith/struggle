module Instructions

  # The topmost level of instructions used to represent a single game.

  class Game < Instruction

    def action
      instructions = []

      instructions << Setup.new
      instructions << EarlyPhase.new
      instructions << MidPhase.new
      instructions << LatePhase.new
      instructions << FinalScoring.new
      instructions << EndGame.new

      instructions
    end

  end

end
