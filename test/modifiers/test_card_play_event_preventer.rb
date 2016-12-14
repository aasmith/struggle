require "helper"

module ModifierTests
  class CardPlayEventPreventerTest < Struggle::Test

    def setup
      @move = Move.new(
        player: US,
        instruction: Instructions::PlayCard.new(
          player: US,
          card_ref: "Nato",
          card_action: :event
        )
      )

      @mod = Modifiers::Permission::CardPlayEventPreventer.new(
        card_ref: "Nato",
          reason: "A reason why the card can't be played"
      )
      @mod.cards = TEST_CARDS
    end

    def test_can_play_unblocked_card
      @move.instruction.card_ref = "Blockade"
      assert @mod.allows?(@move)
    end

    def test_cannot_play_blocked_card
      refute @mod.allows?(@move)
    end
  end
end
