module Modifiers::Permission

  # Prevents a specific card from being played for an event.
  #
  # Note that this modifier is not invoked for instances where the
  # event is being triggered as a result of opponent card play.
  # In that case, the play _is_ valid, but the event is essentially
  # a no-op. That case should be handled by the event directly.

  class CardPlayEventPreventer < PermissionModifier

    needs :cards

    fancy_accessor :card_ref, :reason

    def initialize(card_ref:, reason:)
      self.card_ref = card_ref
      self.reason = reason
    end

    def allows?(move)

      if playing_card_for_event?(move)

        card = cards.find_by_ref card_ref

        log %{"%s" cannot be played as an event. %s} % [
          card.name,
          reason
        ]

        return false
      end

      return true
    end

    def playing_card_for_event?(move)
      Move === move &&
        Instructions::PlayCard === move.instruction &&
        move.instruction.card_ref == card_ref &&
        move.instruction.card_action == :event
    end
  end
end
