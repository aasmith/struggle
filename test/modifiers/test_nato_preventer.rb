require "helper"

module ModifierTests
  class NatoPreventerTest < Struggle::Test

    def setup
      @move = Move.new(
        player: US,
        instruction: Instructions::PlayCard.new(
          player: US,
          card_ref: "Nato",
          card_action: :event
        )
      )

      @mod = Modifiers::Permission::NatoPreventer.new
      @mod.events_in_effect = EventsInEffect.new
    end

    def test_can_play_nato_if_marshall_plan_in_effect
      @mod.events_in_effect.add "MarshallPlan"

      assert @mod.allows?(@move)
    end

    def test_can_play_nato_if_warsaw_pact_in_effect
      @mod.events_in_effect.add "WarsawPactFormed"

      assert @mod.allows?(@move)
    end

    def test_cannot_play_nato_if_events_not_in_effect
      refute @mod.allows?(@move)
    end
  end
end
