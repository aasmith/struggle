module Events
  module CardEvents

    # The NATO event is implemented using several mechanisms. This is the
    # canonical list of them.
    #
    # NATO cannot be played as a card for the event until certain events have
    # occured. This is enforced in the NatoPreventer class. It prevents the
    # card from being played directly. The NatoPreventer class is installed
    # into the engine at game initialization time, and is consulted on each
    # engine iteration.
    #
    # The NATO event can still be played prematurely by other means. For
    # instance, the US player may have it invoked on their behalf due to the
    # USSR playing it for ops. In this case, the event logic below is executed
    # but returns early without triggering the actual event. This is a subtle
    # difference from the above example, as the initial card play by the USSR
    # is valid, and therefore not in scope for the NatoPreventer class.
    #
    # The NATO event, when it finally executes in full, puts the Nato
    # permission modifier into effect. This modifier prevents the player
    # from couping/realigning in US-controlled countries in Europe. This class
    # is also aware of the Willy Brandt/De Gaulle Leads France cards that leave
    # Germany/France exposed. The BrushWar event is aware of the NATO event
    # when determining a list of coupable countries.

    class Nato < Instruction

      needs :events_in_effect

      def action
        instructions = []

        unless marshall_plan_or_warsaw_pact_in_effect?
          log "The event for NATO will not be executed, as neither of the " \
              "Marshall Plan or Warsaw Pact Formed events have occurred."

          return []
        end

        instructions << Instructions::AddPermissionModifier.new(
          modifier_name: "Nato"
        )

        instructions << Instructions::PlaceInEffect.new(
          card_ref: "Nato"
        )

        instructions << Instructions::Remove.new(
          card_ref: "Nato"
        )

        instructions
      end

      def marshall_plan_or_warsaw_pact_in_effect?
        events_in_effect.include?("MarshallPlan") ||
        events_in_effect.include?("WarsawPactFormed")
      end

    end

  end
end
