module Instructions
  class SetPhasingPlayer < Instruction
    fancy_accessor :player

    needs :phasing_player

    def initialize(player:)
      super

      self.player = player
    end

    def action
      log "%4s is now the phasing player" % player

      phasing_player.player = player
    end

    def needs_raw?
      true
    end
  end
end
