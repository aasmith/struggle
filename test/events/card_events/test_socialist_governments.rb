require "helper"

module CardEventTests
  class SocialistGovernmentsTest < Struggle::Test

    def test_nothing_happens_when_iron_lady_in_effect
      event = Events::CardEvents::SocialistGovernments.new
      event.events_in_effect = EventsInEffect.new(["TheIronLady"])

      instructions = event.execute

      assert_equal [Instructions::Discard], instructions.map(&:class)
    end

    def test_vp_award
      event = Events::CardEvents::SocialistGovernments.new
      event.events_in_effect = EventsInEffect.new
      event.countries = Countries.new([])

      instructions = event.execute

      assert_equal [Arbitrators::RemoveInfluence, Instructions::Discard],
        instructions.map(&:class)
    end

  end
end

