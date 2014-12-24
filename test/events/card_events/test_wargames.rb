require "helper"

module CardEventTests
  class WargamesTest < Struggle::Test

    def test_nothing_happens_when_defcon_above_two
      event = Events::CardEvents::Wargames.new
      event.defcon = FakeDefcon.new(3)

      instructions = event.execute

      assert_equal [Instructions::Discard], instructions.map(&:class)
    end

    def test_wargames_occur_at_defcon_two
      event = Events::CardEvents::Wargames.new
      event.phasing_player = US
      event.defcon = FakeDefcon.new(2)

      instructions = event.execute

      assert_equal [Arbitrators::Basic, Instructions::Remove],
        instructions.map(&:class)

      arb, _ = instructions

      assert_equal US, arb.player
      assert_equal Events::CardEvents::Wargames::INPUTS, arb.allows
    end

    FakeDefcon = Struct.new(:value)

  end
end

