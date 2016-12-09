require "helper"

module CardEventTests
  class NatoTest < Struggle::Test

    def setup
      @event = Events::CardEvents::Nato.new
      @event.events_in_effect = EventsInEffect.new
    end

    def test_event_happens_when_marshall_plan_in_effect
      @event.events_in_effect.add "MarshallPlan"

      assert_nato_event @event.action
    end

    def test_event_happens_when_warsaw_pact_formed_in_effect
      @event.events_in_effect.add "WarsawPactFormed"

      assert_nato_event @event.action
    end

    def test_event_happens_when_both_events_in_effect
      @event.events_in_effect.add "MarshallPlan"
      @event.events_in_effect.add "WarsawPactFormed"

      assert_nato_event @event.action
    end

    def test_event_not_triggered_when_neither_events_in_effect
      assert_empty @event.action
    end

    def assert_nato_event instructions
      refute_empty instructions, "There should be instructions for the event"

      add_permission_modifier, place_in_effect, remove_from_play = *instructions

      assert_permission_added "Nato", add_permission_modifier
      assert_placed_in_effect "Nato", place_in_effect
      assert_removed_from_play "Nato", remove_from_play
    end
  end
end
