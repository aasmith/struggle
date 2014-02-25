require "helper"

class ArbitratorTests::CardPlayTest < Struggle::Test

  def setup
    # A two-part move sequence: USSR playing US card
    @event_move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "Defectors",
        card_action: :event
      )
    )

    @ops_move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "Defectors",
        card_action: :influence
      )
    )

    # A regular one-part move: USSR playing USSR card
    @single_move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "SocialistGovernments",
        card_action: :influence
      )
    )

    # Playing the china card for influence.
    @china_move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "TheChinaCard",
        card_action: :influence
      )
    )

    # Playing the china card for event.
    @china_event = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "TheChinaCard",
        card_action: :event
      )
    )

    # Spacing an opponent event card
    @space_move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "Defectors",
        card_action: :space
      )
    )

    # Playing a card the player doesn't have
    @bad_card_move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,
        card_ref: "SuezCrisis",
        card_action: :event
      )
    )

    # Player acknowledging that they are unable to play.
    @noop = EmptyMove.new(
      player: USSR,
      instruction: Instructions::Noop.new
    )

    cards = Cards.new

    # the laziest way to set move.instruction.cards on
    # all those moves that were just created.
    instance_variables.each do |iv|
      target = instance_variable_get(iv)

      if target.respond_to?(:instruction) &&
         target.instruction.respond_to?(:cards=)

        target.instruction.cards = cards
      end
    end

    @arb = Arbitrators::CardPlay.new(player: USSR)

    @arb.cards = cards
    @arb.hands = Hands.new
    @arb.china_card = ChinaCard.new

    # Give the USSR two cards
    @arb.hands.add(USSR, @arb.cards.find_by_ref("SocialistGovernments"))
    @arb.hands.add(USSR, @arb.cards.find_by_ref("Defectors"))

    # Give the US a card
    @arb.hands.add(US, @arb.cards.find_by_ref("SuezCrisis"))
  end

  def test_single_play
    assert @arb.accepts?(@single_move), "Should accept player's own card"

    @arb.accept @single_move

    assert @arb.complete?, "Arb should be complete after playing own card"
  end

  def test_two_part_play_event_then_ops
    assert @arb.accepts?(@event_move), "Should accept opponent card for event"
    @arb.accept @event_move

    refute @arb.complete?,
      "Arb should be incomplete after one move when playing an opponent card"

    assert @arb.accepts?(@ops_move), "Should accept opponent card for ops"
    @arb.accept @ops_move

    assert @arb.complete?,
      "Arb should be complete after two moves when playing opponent card"
  end

  def test_two_part_play_ops_then_event
    assert @arb.accepts?(@ops_move), "Should accept opponent card for ops"
    @arb.accept @ops_move

    refute @arb.complete?,
      "Arb should be incomplete after one move when playing an opponent card"

    assert @arb.accepts?(@event_move), "Should accept opponent card for event"
    @arb.accept @event_move

    assert @arb.complete?,
      "Arb should be complete after two moves when playing opponent card"
  end

  def test_two_part_play_doesnt_accept_two_events
    @arb.accept @event_move

    refute @arb.accepts?(@event_move), "Should not accept another event"
  end

  def test_two_part_play_doesnt_accept_two_operations
    @arb.accept @ops_move

    %i(space coup realignment influence).each do |card_action|
      another_ops_move = EmptyMove.new(
        player: USSR,
        instruction: Instructions::PlayCard.new(
          player: USSR,
          card_ref: "Defectors",
          card_action: card_action
        )
      )

      refute @arb.accepts?(another_ops_move),
        "Should not accept another operation"
    end
  end

  def test_two_part_play_only_accepts_same_card_for_each_step
    assert @arb.accepts?(@event_move), "Should accept opponent card for event"
    @arb.accept(@event_move)

    # card will be removed from hand by some instruction...
    @arb.hands.remove(USSR, "Defectors")

    refute @arb.accepts?(@bad_card_move), "Should not accept a different card"

    assert @arb.accepts?(@ops_move), "Should accept opponent card for ops"
    @arb.accept(@ops_move)
  end

  def test_play_of_china_card_with_possession
    assert @arb.accepts?(@china_move), "Should accept china card"

    @arb.accept @china_move

    assert @arb.complete?, "Arb should be complete after playing china card"
  end

  def test_china_card_cannot_be_played_when_face_down
    @arb.china_card.playable = false
    refute @arb.accepts?(@china_move), "Should reject unplayable china card"
  end

  def test_china_card_cannot_be_played_when_held_by_opponent
    @arb.china_card.holder = US
    refute @arb.accepts?(@china_move), "Should reject opponent-held china card"
  end

  def test_china_card_cannot_be_played_for_event
    refute @arb.accepts?(@china_event), "Should reject china card for event"
  end

  def test_spacing_opponent_card_is_a_single_play
    assert @arb.accepts?(@space_move), "Should accept card for space"

    @arb.accept @space_move

    assert @arb.complete?, "Arb should be complete after spacing a card"
  end

  def test_card_cannot_be_played_if_not_held
    refute @arb.accepts?(@bad_card_move), "Should reject a card not in hand"
  end

  def test_card_play_cannot_be_skipped_if_cards_in_hand
    refute @arb.accepts?(@noop), "Cannot arbitrarily skip playing of a card"
  end

  def test_card_play_can_be_skipped_if_no_cards_in_hand
    # No more cards left...
    @arb.hands.clear(USSR)

    # USSR still has the china card, but playing of the china card can never
    # be compelled.

    assert @arb.accepts?(@noop), "Can skip card play when hand is empty"

    @arb.accept(@noop)

    assert @arb.complete?, "Arb should be complete after skipping play"
  end

  def test_playing_last_card_in_hand_in_two_parts_denies_noop
    # When playing as two parts, the card is removed from the hand on the
    # first part. This leaves open the possibility that the player may
    # try to play a noop on the second part, as the arb might naively check
    # the hand. When it sees it is empty, it could incorrectly allow a noop.

    # Reduce hand to one card.
    @arb.hands.clear(USSR)
    @arb.hands.add(USSR, "Defectors")

    # Play first part.
    @arb.accept @event_move

    # Remove the card from hand.
    @arb.hands.clear(USSR)

    refute @arb.accepts?(@noop), "Noop must be rejected playing second part"
  end

end
