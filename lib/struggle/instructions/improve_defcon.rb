module Instructions
  class ImproveDefcon < Instruction
    needs :defcon

    def action
      defcon.improve(1)
    end
  end
end
