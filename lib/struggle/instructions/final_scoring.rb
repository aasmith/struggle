module Instructions

  # TODO add final region scoring

  class FinalScoring < Instruction

    def action
      instructions = []

      instructions << AwardChinaCardHolder.new

      instructions
    end
  end
end
