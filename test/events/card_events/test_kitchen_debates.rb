require "helper"

module CardEventTests
  class KitchenDebatesTest < Struggle::Test

    def setup
      @event = Events::CardEvents::KitchenDebates.new
      @event.countries = Countries.new([])
    end

    def test_two_vp_awarded_when_us_has_more_battlegrounds
      us_controls_more_battlegrounds

      instructions = @event.action

      award_vp, remove = *instructions

      assert_equal 2, instructions.size
      assert_award_vp 2, US, award_vp
      assert_remove "KitchenDebates", remove
    end

    def test_nothing_happens_when_us_has_less_battlegrounds
      ussr_controls_more_battlegrounds
      instructions = @event.action

      assert_equal 1, instructions.size
      assert_discard "KitchenDebates", instructions.first
    end

    def test_nothing_happens_when_us_has_equal_battlegrounds
      instructions = @event.action

      assert_equal 1, instructions.size
      assert_discard "KitchenDebates", instructions.first
    end

    def us_controls_more_battlegrounds
      @event.countries = Countries.new([
        FakeBattlegroundCountry.new(controlled_by: US)
      ])
    end

    def ussr_controls_more_battlegrounds
      @event.countries = Countries.new([
        FakeBattlegroundCountry.new(controlled_by: USSR)
      ])
    end

  end

  class FakeBattlegroundCountry
    def initialize(controlled_by:)
      @controlled_by = controlled_by
    end

    def controlled_by?(player)
      @controlled_by == player
    end

    def battleground?
      true
    end
  end
end
