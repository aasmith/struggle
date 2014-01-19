module Instructions
  class NestingInstruction < Instruction
    def initialize(*instructions)
      super()

      unless instructions.all? { |i| WorkItem === i }
        bad = instructions.reject { |i| i.is_a? WorkItem }
        raise "Bad list items: #{bad.inspect}"
      end

      @instructions = instructions
    end

    def action
      @instructions
    end
  end
end
