module Instructions

  # Uses Kernel#puts to print a message.
  #
  # Useful for debugging.

  class Puts < Instruction
    def initialize(message:)
      super
      @message = message
    end

    def action
      puts @message
    end
  end
end
