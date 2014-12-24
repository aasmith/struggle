module Instructions
  class WargamesAwardVp < Instruction

    needs :phasing_player

    def action
      instructions = []

      log "%4s chooses to award %s 6 VP..." % [
        phasing_player,
        phasing_player.opponent
      ]

      instructions << Instructions::AwardVictoryPoints.new(
        player: phasing_player.opponent,
        amount: 6
      )

      instructions
    end

  end
end
