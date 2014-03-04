##
# Encapsulates playing a card. Returns the appropriate
# instructions/arbitrators for the selected card action.
#
module Instructions
  class PlayCard < Instruction

    fancy_accessor :player, :card_ref, :card_action

    needs :cards, :observers

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

      instructions.push(*lookup_instructions(card_ref, card_action))
      instructions.push(*send(card_action))
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
      Arbitrators::AddRestrictedInfluence.new(
        player: player,
        influence: player,
        ops_counter: ops_counter
      )
    end

    def coup
      Arbitrators::Coup.new(
        player: player,
        ops_counter: ops_counter
      )
    end

    def realignment
      Arbitrators::Realignment.new(
        player: player,
        ops_counter: ops_counter
      )
    end

    def space
      # Space race is not an arbitrator simply because there isnt anything
      # to arbitrate. Once a player has declared they are space racing, the
      # only thing they can do is attempt a space race, with no further
      # parameters to be provided.
      #
      # The guard (Guards::Space), prevents the space race from being
      # attempted if the player doesnt qualify.

      Instructions::AttemptSpaceRace.new(
        player: player,
        card_ref: card_ref
      )
    end

    def card
      cards.find_by_ref(card_ref)
    end

    def ops_counter
      mods = observers.ops_modifiers_for_player(player)

      OpsCounter.new(card.ops!, mods)
    end

    def to_s
      opponent =
        card.side == player.opponent && card_action == :event ?
        "opponent " : ""

      "%4s plays %s for %s%s" % [
        player, card.inspect, opponent, card_action
      ]
    end

  end
end
