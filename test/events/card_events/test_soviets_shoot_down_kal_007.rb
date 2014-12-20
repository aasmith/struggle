require "helper"

module CardEventTests
  class SovietsShootDownKal007Test < Struggle::Test

    def play_card_with_south_korea_controlled_by(player)
      korea = FakeCountry.new(controlled_by: player)
      countries = FakeCountries.new(korea)

      event = Events::CardEvents::SovietsShootDownKal007.new
      event.countries = countries

      event.execute
    end

    def test_free_move_when_korea_us_controlled
      instructions = play_card_with_south_korea_controlled_by(US)

      assert_includes instructions.map(&:class), Arbitrators::FreeMove

      free_move = instructions.detect do |i|
        Arbitrators::FreeMove === i
      end

      assert_equal %i(influence realignment), free_move.only
      assert_equal 4, free_move.ops
      assert_equal US, free_move.player
    end

    def test_no_free_move_when_korea_not_us_controlled
      instructions = play_card_with_south_korea_controlled_by(USSR)

      refute_includes instructions.map(&:class), Arbitrators::FreeMove


      instructions = play_card_with_south_korea_controlled_by(nil)

      refute_includes instructions.map(&:class), Arbitrators::FreeMove
    end

    class FakeCountry
      def initialize(controlled_by:)
        @controlled_by = controlled_by
      end

      def controlled_by?(player)
        @controlled_by == player
      end
    end

  end
end
