require "helper"

module GuardTests
  class RealignmentTest < Struggle::Test

    def setup
      @move = EmptyMove.new(
        player: US,
        instruction: Instructions::PlayCard.new(
               player: US,
             card_ref: "Anything",
          card_action: :realignment
        )
      )

      @guard = Guards::Realignment.new(@move)

      @guard.countries = [presence, presence, empty]
      @guard.observers = Observers.new([])
      @guard.defcon    = BlanketDefcon.new(prevents_everything: false)
    end

    def test_allows_when_valid_target_countries
      assert @guard.allows?,
        "Countries with presence and no DEFCON should be realignable"
    end

    def test_rejects_when_no_realignable_countries
      @guard.countries = [empty, empty, empty]

      refute @guard.allows?, "Empty countries cant be realigned"
    end

    def test_rejects_when_defcon_blocks_all_countries
      @guard.defcon = BlanketDefcon.new(prevents_everything: true)

      refute @guard.allows?, "DEFCON should prevent a realignment anywhere"
    end

    def presence
      FakeCountry.new(true)
    end

    def empty
      FakeCountry.new(false)
    end

    class FakeCountry
      def initialize(presence)
        @presence = presence
      end

      def presence?(_)
        @presence
      end
    end

  end
end

