##
# An instruction that does nothing. Typically used to signal that a player
# is either unable or is electing not to play.
#
module Instructions
  class Noop < Instruction
    def action
    end
  end
end
