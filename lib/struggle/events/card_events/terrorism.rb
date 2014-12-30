module Events
  module CardEvents

    class Terrorism < Instruction

      needs :hands, :events_in_effect, :phasing_player

      def action
        instructions = []

        opponent = phasing_player.opponent
        qty = double_effect? ? 2 : 1

        # Create a working copy of the hand for this scope only. Even though
        # the cards are removed from the hand and then discarded, the removal
        # from hand won't occur until the instructions are passed up to the
        # parent. Therefore, we need to remove the cards here so the same card
        # cannot be picked from the hand twice.

        hand = Array.new(hands.get(opponent))

        log "%s %s will be chosen randomly from %s hand and discarded" % [
          qty,
          qty > 1 ? "cards" : "card",
          opponent
        ]

        qty.times do |i|

          card = hand.delete hand.sample

          if card.nil?
            log "%s hand is empty, nothing left to discard." % opponent

          else
            instructions << Instructions::RemoveCardFromHand.new(
                player: opponent,
              card_ref: card.ref
            )

            instructions << Instructions::Discard.new(
              card_ref: card.ref
            )

          end

        end

        instructions << Instructions::Discard.new(
          card_ref: "Terrorism"
        )

        instructions
      end

      def double_effect?
        phasing_player.ussr? &&
          events_in_effect.include?("IranianHostageCrisis")
      end

    end

  end
end
