module Instructions
  class ResetSpaceRaceAttempts < Instruction
    needs :space_race

    def action
      space_race.reset_attempts
    end
  end
end