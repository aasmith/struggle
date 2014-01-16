require "helper"

class InstructionTests::CardDumpersTest < Struggle::Test

  def test_discard
    discards = []

    instruction = Instructions::Discard.new(card_ref: "SomeCard")
    instruction.cards = FakeCards.new
    instruction.discards = discards

    instruction.action

    assert_equal %w(SomeCard), discards, "discards should have a card added"
  end

  def test_remove
    removed = []

    instruction = Instructions::Remove.new(card_ref: "SomeCard")
    instruction.cards = FakeCards.new
    instruction.removed = removed

    instruction.action

    assert_equal %w(SomeCard), removed, "removed should have a card added"
  end

  def test_limbo
    limbo = []

    instruction = Instructions::Limbo.new(card_ref: "SomeCard")
    instruction.cards = FakeCards.new
    instruction.limbo = limbo

    instruction.action

    assert_equal %w(SomeCard), limbo, "limbo should have a card added"
  end

  class FakeCards
    def find_by_ref(ref)
      ref
    end
  end
end
