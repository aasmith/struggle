##
# An instruction that does nothing. Typically used to signal that a player
# is either unable or is electing not to play.
#
module Instructions
  class Noop < Instruction

    fancy_accessor :label

    def initialize(label: nil)
      super

      self.label = label
    end

    def action
      log label if label
    end
  end
end

