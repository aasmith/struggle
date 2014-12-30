require "helper"

module CardEventTests
  class TerrorismTest < Struggle::Test

    @@cards = Cards.new

    def setup
      @hands = Hands.new
      @hands.add(US, @@cards.find_by_ref("Nato"))
      @hands.add(US, @@cards.find_by_ref("AnEvilEmpire"))

      @hands.add(USSR, @@cards.find_by_ref("Fidel"))
      @hands.add(USSR, @@cards.find_by_ref("Blockade"))

      @event = Events::CardEvents::Terrorism.new
      @event.events_in_effect = EventsInEffect.new(["IranianHostageCrisis"])
      @event.phasing_player = US
      @event.hands = @hands

      # Rig the hand to not be a random sample.
      def @hands.get(player)
        hand = [*super]

        def hand.sample
          first
        end

        hand
      end
    end

    def test_discards_one
      instructions = @event.action

      assert_equal 3, instructions.size

      remove, discard, dispose = instructions

      assert_instance_of Instructions::RemoveCardFromHand, remove
      assert_instance_of Instructions::Discard, discard
      assert_instance_of Instructions::Discard, dispose

      card_ref = remove.card_ref
      assert_includes %w(Fidel Blockade), card_ref

      assert_equal USSR, remove.player
      assert_equal card_ref, remove.card_ref

      assert_equal card_ref, discard.card_ref

      assert_equal "Terrorism", dispose.card_ref
    end

    def test_discards_two_when_ussr_and_double_effect
      @event.phasing_player = USSR

      instructions = @event.action

      assert_equal 5, instructions.size

      remove, discard, remove2, discard2, dispose = instructions

      assert_instance_of Instructions::RemoveCardFromHand, remove
      assert_instance_of Instructions::Discard, discard
      assert_instance_of Instructions::RemoveCardFromHand, remove2
      assert_instance_of Instructions::Discard, discard2
      assert_instance_of Instructions::Discard, dispose

      refute_equal remove.card_ref, remove2.card_ref,
        "Should remove two different cards"

      card_ref = remove.card_ref
      assert_includes %w(Nato AnEvilEmpire), card_ref

      assert_equal US, remove.player
      assert_equal card_ref, remove.card_ref
      assert_equal card_ref, discard.card_ref

      card_ref = remove2.card_ref
      assert_includes %w(Nato AnEvilEmpire), card_ref

      assert_equal US, remove2.player
      assert_equal card_ref, remove2.card_ref
      assert_equal card_ref, discard2.card_ref

      assert_equal "Terrorism", dispose.card_ref
    end

    def test_partial_discard_on_tiny_hand
      @event.phasing_player = USSR

      # Make hand small
      @hands.remove(US, @@cards.find_by_ref("AnEvilEmpire"))

      instructions = @event.action

      assert_equal 3, instructions.size

      remove, discard, dispose = instructions

      assert_instance_of Instructions::RemoveCardFromHand, remove
      assert_instance_of Instructions::Discard, discard
      assert_instance_of Instructions::Discard, dispose

      assert_equal US, remove.player
      assert_equal "Nato", remove.card_ref
      assert_equal "Nato", discard.card_ref

      assert_equal "Terrorism", dispose.card_ref
    end

  end
end
