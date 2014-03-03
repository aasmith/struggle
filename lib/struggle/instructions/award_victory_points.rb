module Instructions
  class AwardVictoryPoints < Instruction
    fancy_accessor :player, :amount

    needs :victory_track

    def initialize(player:, amount:)
      super

      self.player = player
      self.amount = amount
    end

    def action
      log "%4s is awarded %s Victory Points." % [player, amount]

      victory_track.award(player, amount)
    end
  end
end
