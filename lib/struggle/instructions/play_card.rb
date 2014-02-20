##
# Encapsulates playing a card. Returns the appropriate
# instructions/arbitrators for the selected card action.
#
module Instructions
  class PlayCard < Instruction

    fancy_accessor :player, :card_ref, :card_action

    needs :observers

    VALID_CARD_ACTIONS = %i(event influence coup realignment space)

    def initialize(player:, card_ref:, card_action:)
      super

      self.player = player
      self.card_ref = card_ref
      self.card_action = card_action

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

      instructions = [remove_from_hand, add_to_current_cards]

      # Get instructions from card_components. These are mainly for events,
      # although the china card is an exception to this; it has instructions
      # for influence/coup/realign.
      #
      # Execute these instructions (if any) before delegating to the
      # influence/coup/realignment/space methods below.

      instructions += lookup_instructions card_ref, card_action
      instructions += send card_action
      instructions
    end

    # TODO Get instructions from card_components list
    def lookup_instructions(card_ref, card_action)
      [Noop.new]
    end

    # Nothing else to do.
    def event
      []
    end

    def influence
      ops_modifiers = observers.ops_modifiers_for_player(player)
      ops_counter   = OpsCounter.new(card.ops, ops_modifiers)

      Arbitrators::AddRestrictedInfluence.new(
        player: player,
        influence: player,
        ops_counter: ops_counter
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
