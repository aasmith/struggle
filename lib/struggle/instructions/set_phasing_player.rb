module Instructions
  class SetPhasingPlayer < Instruction
    arguments :player

    needs :phasing_player

    def action
      phasing_player.player = player
    end
  end
end
