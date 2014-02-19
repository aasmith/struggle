module Instructions
  class ClaimChinaCard < Instruction
    fancy_accessor :player, :playable

    needs :china_card

    def initialize(player:, playable:)
      super

      self.player = player
      self.playable = playable
    end

    def action
      china_card.holder = player
      china_card.playable = playable
    end
  end
end
