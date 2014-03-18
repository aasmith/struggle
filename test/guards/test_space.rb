require "helper"

module GuardTests
  class SpaceTest < Struggle::Test

    def setup
      @move = EmptyMove.new(
        player: US,
        instruction: Instructions::PlayCard.new(
               player: US,
             card_ref: "Anything",
          card_action: :space
        )
      )

      @guard = Guards::Space.new(@move)

      card = FakeCard.new(3)

      @guard.cards      = Cards.new([card])
      @guard.observers  = Observers.new([])
      @guard.space_race = SpaceRace.new
    end

    def test_rejects_if_space_race_complete
      @guard.space_race = CompleteSpaceRace.new
      refute @guard.allows?

      @guard.space_race = SpaceRace.new
      assert @guard.allows?
    end

    def test_rejects_if_all_attempts_used
      @guard.space_race = ExhaustedSpaceRace.new
      refute @guard.allows?

      @guard.space_race = SpaceRace.new
      assert @guard.allows?
    end

    def test_rejects_if_not_enough_ops_points
      card = FakeCard.new(1)

      @guard.cards = Cards.new([card])
      refute @guard.allows?

      card = FakeCard.new(3)

      @guard.cards = Cards.new([card])
      assert @guard.allows?
    end

    def test_allows_when_all_conditions_satisified
      assert @guard.allows?
    end

    class CompleteSpaceRace < SpaceRace
      def complete?(_)
        true
      end
    end

    class ExhaustedSpaceRace < SpaceRace
      def attempts(_)
        1
      end
    end

    class FakeCard < Card
      def initialize(ops)
        @ops = ops
      end

      def ref
        "Anything"
      end

      def ops!
        @ops
      end
    end

  end
end


