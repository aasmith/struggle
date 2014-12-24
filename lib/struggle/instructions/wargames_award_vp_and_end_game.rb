module Instructions
  class WargamesAwardVpAndEndGame < Instruction

    needs :phasing_player

    def action
      instructions = []

      log "%4s chooses to award %s 6 VP and end the game!" % [
        phasing_player,
        phasing_player.opponent
      ]

      instructions << Instructions::AwardVictoryPoints.new(
        player: phasing_player.opponent,
        amount: 6
      )

      # This may not happen if the VP award leads to a VP-based victory.

      instructions << DeclareWinner.new(
        player: phasing_player,
        reason: "Wargames"
      )

      instructions
    end

  end
end
