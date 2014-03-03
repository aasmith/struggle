module Arbitrators

  class CardPlay < MoveArbitrator

    fancy_accessor :player, :optional

    needs :deck, :china_card, :hands, :cards, :guard_resolver

    # used for tracking state over two-instruction plays
    attr_accessor :previous_card, :previous_action

    def initialize(player:, optional: false)
      super

      self.player = player

      # Is this an optional play? The player can pass by playing
      # a Noop instruction.
      self.optional = optional
    end

    def before_execute(move)
      log move.instruction.to_s
    end

    def after_execute(move)
      if noop?(move) || second_part?
        complete
      else
        card = cards.find_by_ref(move.instruction.card_ref)

        if card.side == player.opponent && !space?(move)
          self.previous_card   = move.instruction.card_ref
          self.previous_action = move.instruction.card_action
        else
          complete
        end
      end
    end

    ##
    # Checks the move is valid against numerous conditions.
    #
    # If the player is unable to play a card (i.e. empty hand) then accept
    # a noop instruction.
    #
    # Otherwise, check the move contains a CardPlay instruction and that the
    # player has the card in hand (or is playable in the case of the china
    # card).
    #
    # Asserts the particular action cannot get the game into an unplayable
    # state. Checks the appropriate action Guard.
    #
    # If the card contains an opponent event, then also verify that two moves
    # are played -- one for an event and one for an operation, in either order
    # and using the same card.
    #
    # If the card contains an opponent event, but is being spaced, then ensure
    # a one part move.
    #
    # If this CardPlay is optional, then allow the player to play as normal
    # or accept a Noop instruction to pass.
    #
    def accepts?(move)
      return false if incorrect_player?(move)
      return false if eventing_china_card?(move)

      if able_to_play? && !optional?
        playing_valid_card_allowed_by_guard?(move)

      elsif able_to_play? && optional?
        playing_valid_card_allowed_by_guard?(move) or noop?(move)

      else
        noop?(move)

      end
    end

    ##
    # The player is able to play if this is the second part of a card play,
    # or their hand is not empty.
    #
    def able_to_play?
      second_part? || !hands.hand(player).empty?
    end

    def playing_valid_card_allowed_by_guard?(move)
      card_play?(move) && valid_card?(move) && guard_allows?(move)
    end

    def noop?(move)
      Instructions::Noop === move.instruction
    end

    def card_play?(move)
      Instructions::PlayCard === move.instruction
    end

    def valid_card?(move)
      if second_part?
        same_card_as_previous?(move) && opposing_action?(move)
      else
        card_in_possession?(move)
      end
    end

    # Delegates to the guard if the move is an operation, otherwise returns
    # true.

    def guard_allows?(move)
      if OPERATIONS.include?(move.instruction.card_action)
        guard_resolver.resolve(move).allows?
      else
        true
      end
    end

    def space?(move)
      move.instruction.card_action == :space
    end

    def opposing_action?(move)
      action = move.instruction.card_action

      if action == :event
        OPERATIONS.include?(previous_action)
      else
        previous_action == :event
      end
    end

    def same_card_as_previous?(move)
      previous_card && previous_card == move.instruction.card_ref
    end

    def card_in_possession?(move)
      card = cards.find_by_ref(move.instruction.card_ref)

      if card.china_card?
        china_card.playable_by?(player)
      else
        hands.hand(player).include?(card)
      end
    end

    ##
    # Is this the second part of a two-part move?
    #
    # This is only known for sure once the first move has been executed.
    #
    def second_part?
      previous_card || previous_action
    end


    # Rejects any attempt to play the China Card as an event.

    def eventing_china_card?(move)
      return false unless Instructions::PlayCard === move.instruction

      card = cards.find_by_ref(move.instruction.card_ref)

      card.china_card? && move.instruction.card_action == :event
    end

    alias optional? optional

  end

end
