module Instructions
  class AwardVictoryPoints < Instruction
    arguments :player, :amount

    needs :victory_point_track

    def action
      victory_point_track.award(player, amount)
    end
  end
end
