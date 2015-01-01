require "helper"

module CardEventTests
  class FiveYearPlanTest < Struggle::Test

    def setup
      @hands = Hands.new

      @event = Events::CardEvents::FiveYearPlan.new
      @event.events = FakeEventFinder.new
      @event.hands  = @hands
    end

    def test_nothing_when_ussr_has_empty_hand
      instructions = @event.action

      assert_equal 1, instructions.size
      assert_equal [Instructions::Discard], instructions.map(&:class)
    end

    def test_nothing_when_card_is_ussr
      @hands.add(USSR, FakeCard.new(USSR))
      instructions = @event.action

      assert_equal 1, instructions.size
      assert_equal [Instructions::Discard], instructions.map(&:class)
    end

    def test_nothing_when_card_is_neutral
      @hands.add(USSR, FakeCard.new(nil))
      instructions = @event.action

      assert_equal 1, instructions.size
      assert_equal [Instructions::Discard], instructions.map(&:class)
    end

    def test_event_fires_when_card_is_us
      @hands.add(USSR, FakeCard.new(US))
      event, discard = @event.action

      assert_instance_of Instructions::Noop, event
      assert_instance_of Instructions::Discard, discard

      assert_equal "SelectedCard:#{EVENT}", event.label
    end

    class FakeCard < Card
      def initialize(side)
        @side = side
        @ref  = "SelectedCard"
      end
    end

  end
end
