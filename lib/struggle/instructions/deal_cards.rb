##
# Deals cards from the deck. If there are no more cards in the deck,
# the +discard+ pile is transferred into the deck.
#
module Instructions
  class DealCards < Instruction
    fancy_accessor :target

    needs :deck, :hands, :discards

    def initialize(target:)
      super

      self.target = target
    end

    def action
      satisfied = { US => false, USSR => false }

      until satisfied.values.all? do
        [USSR, US].each do |player|
          if hands.get(player).size < target
            if deck.empty?
              deck.add discards
              discards.clear
            end

            hands.add(player, deck.draw)
          else
            satisfied[player] = true
          end
        end
      end
    end
  end
end
