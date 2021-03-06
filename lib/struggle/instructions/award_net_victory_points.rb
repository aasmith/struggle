module Instructions

  # An instruction for awarding a net gain of Victory Points.
  #
  # When awarding both players VP at the same time, instead of giving
  # points to both, the points must be awarded to a single player using
  # the net gain, per 10.2.3.

  class AwardNetVictoryPoints < Instruction
    fancy_accessor :players, :amounts

    def initialize(players:, amounts:)
      super

      if amounts.any? { |a| a < 0 }
        fail ArgumentError, "Negative amounts are not allowed"
      end

      self.players = players
      self.amounts = amounts
    end

    def action
      instructions = []

      player, amount = calcuate_net_award(players, amounts)

      unless amount.zero?
        instructions << Instructions::AwardVictoryPoints.new(
          player: player,
          amount: amount
        )
      end

      instructions
    end

    def calcuate_net_award(players, amounts)
      player_a, player_b = players
      value_a,  value_b  = amounts

      player = (value_a > value_b) ? player_a : player_b
      award  = (value_a - value_b).abs

      [player, award]
    end

    def points_for(player)
      # Used for testing

      _, points = players.zip(amounts).assoc(player)

      points
    end

  end
end
