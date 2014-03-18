module Instructions

  class Setup < Instruction

    def action
      instructions = []

      instructions << AddToDeck.new(phase: :early)

      instructions << DealCards.new(target: 8)

      instructions << ClaimChinaCard.new(player: USSR, playable: true)

      instructions << StartingInfluence.new

      instructions
    end

  end

end
