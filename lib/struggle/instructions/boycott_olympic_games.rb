module Instructions
  class BoycottOlympicGames < Instruction

    needs :phasing_player

    def action
      instructions = []

      instructions << Instructions::DegradeDefcon.new(
        cause: self
      )

      instructions << Arbitrators::FreeMove.new(
        player: phasing_player,
           ops: 4
      )

      instructions
    end

  end
end
