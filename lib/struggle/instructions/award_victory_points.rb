module Instructions
  class AwardVictoryPoints < Instruction
    fancy_accessor :player, :amount

    needs :victory_point_track

    def initialize(player:, amount:)
      super

      self.player = player
      self.amount = amount
    end

    def action
      victory_point_track.award(player, amount)
    end
  end
end
