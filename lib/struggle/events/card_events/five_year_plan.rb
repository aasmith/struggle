module Events
  module CardEvents

    class FiveYearPlan < Instruction

      needs :events, :hands

      def action
        instructions = []

        hand = hands.get!(USSR)
        card = hand.delete hand.sample

        if card
          log "Card '%s' has been randomly picked from the USSR hand." % [
            card.name
          ]

          if card.us?
            log "The card contains a US event."

            instructions.push(*events.find(card.ref))
          else
            log "The card does not contain a US event."
          end
        else

          log "The USSR has no cards in their hand."
        end

        instructions << Instructions::Discard.new(
          card_ref: "FiveYearPlan"
        )

        instructions
      end

    end

  end
end
