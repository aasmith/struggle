module Instructions
  class PlayerActionRoundEnd < Instruction

    fancy_accessor :player

    def initialize(player:)
      super

      self.player = player
    end

    def action
      log "%4s Action Round has ended" % player
    end
  end
end

