module Modifiers::Permission

  # Prevents card plays of NATO for the event unless Marshall Plan or
  # Warsaw Pact is in effect. Note that this modifier is not invoked for
  # instances where the event is being triggered as a result of opponent
  # card play. In that case, the play _is_ valid, but the event is
  # essentially a no-op. That case is handled by the event directly.

  class NatoPreventer < PermissionModifier

    needs :events_in_effect

    def allows?(move)

      if playing_nato_for_event?(move) && no_marshall_plan? && no_warsaw_pact?
        log "The NATO card cannot be played as an event until Marshall Plan " \
            "or Warsaw Pact Formed are in effect."

        return false
      end

      return true
    end

    def playing_nato_for_event?(move)
      Move === move &&
        Instructions::PlayCard === move.instruction &&
        move.instruction.card_ref == "Nato" &&
        move.instruction.card_action == :event
    end

    def no_marshall_plan?
      !events_in_effect.include? "MarshallPlan"
    end

    def no_warsaw_pact?
      !events_in_effect.include? "WarsawPactFormed"
    end
  end
end
