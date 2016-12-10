module Instructions

  class HeadlinePhase < Instruction

    def action
      instructions = []

      instructions << SetHeadlinePhase.new(active: true)
      instructions << Noop.new(label: "HeadlinePhase is currently unimplemented")
      instructions << SetHeadlinePhase.new(active: false)

      instructions
    end

  end

end
