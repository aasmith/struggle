module Instructions
  class IncrementMilitaryOps < Instruction

    fancy_accessor :player, :amount

    needs :military_ops

    def initialize(player:, amount:)
      super

      self.player = player
      self.amount = amount
    end

    def action
      military_ops.increment(player, amount)
    end
  end
end

