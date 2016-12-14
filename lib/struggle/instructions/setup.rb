module Instructions

  class Setup < Instruction

    def action
      instructions = []

      instructions << AddToDeck.new(phase: :early)

      instructions << DealCards.new(target: 8)

      instructions << ClaimChinaCard.new(player: USSR, playable: true)

      instructions << StartingInfluence.new

      instructions << InitializeMarkers.new

      instructions << PreventPlayOfEvent.new(
        card_ref: "Nato",
          reason: "Marshall Plan or Warsaw Pact must be played for event first."
      )

      instructions << PreventPlayOfEvent.new(
        card_ref: "Solidarity",
          reason: "John Paul II Elected Pope must be played for event first."
      )

      instructions
    end

  end

end
