##
# Encapsulates playing a card. Returns the appropriate
# instructions/arbitrators for the selected card action.
#
module Instructions
  class PlayCard < Instruction

    arguments :player, :card_ref, :card_action

    VALID_CARD_ACTIONS = %i(event influence coup realignment space)

    def after_init
      unless VALID_CARD_ACTIONS.include?(card_action)
        raise "bad card_action #{card_action.inspect}"
      end
    end

    def action
      remove_from_hand = RemoveCardFromHand.new(
        player: player, card_ref: card_ref
      )

      add_to_current_cards = AddCurrentCard.new(
        card_ref: card_ref
      )

      action_instructions = send card_action

      [remove_from_hand, add_to_current_cards, *action_instructions]
    end

    # TODO lookup event instruction list
    def event
      Noop.new
    end

    def influence
      Arbitrators::AddRestrictedInfluence.new(
        player: player,
        influence: player,
        operation_points: ops #TODO determine card ops
      )
    end

    #TODO all of the below

    def coup
      Arbitrators::Coup.new
    end

    def realignment
      Arbitrators::RealignmentRoll.new
    end

    def space
      Arbitrators::SpaceRace.new
    end
  end
end
