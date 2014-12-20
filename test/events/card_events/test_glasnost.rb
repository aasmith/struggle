require "helper"

module CardEventTests
  class GlasnostTest < Struggle::Test

    def test_ussr_free_move_when_reformer_in_effect
      event = Events::CardEvents::Glasnost.new
      event.events_in_effect = EventsInEffect.new(["TheReformer"])

      instructions = event.execute

      assert_includes instructions.map(&:class), Arbitrators::FreeMove

      free_move = instructions.detect do |i|
        Arbitrators::FreeMove === i
      end

      assert_equal USSR, free_move.player
      assert_equal 4, free_move.ops
      assert_equal %i(influence realignment), free_move.only
    end

    def test_no_free_move_when_reformer_not_in_effect
      event = Events::CardEvents::Glasnost.new
      event.events_in_effect = EventsInEffect.new()

      instructions = event.execute

      refute_includes instructions.map(&:class), Arbitrators::FreeMove
    end

  end
end

