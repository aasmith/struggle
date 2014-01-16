require "helper"

class InstructionTests::CardDumpersTest < Struggle::Test

  def setup
    @discards = []
    @removed = []
    @limbo = []

    @discard_instruction = Instructions::Discard.new(card_ref: "SomeCard")
    @discard_instruction.cards = FakeCards.new

    @discard_instruction.discards = @discards
    @discard_instruction.removed = @removed
    @discard_instruction.limbo = @limbo

    @remove_instruction = Instructions::Remove.new(card_ref: "SomeCard")
    @remove_instruction.cards = FakeCards.new

    @remove_instruction.discards = @discards
    @remove_instruction.removed = @removed
    @remove_instruction.limbo = @limbo

    @limbo_instruction = Instructions::Limbo.new(card_ref: "SomeCard")
    @limbo_instruction.cards = FakeCards.new

    @limbo_instruction.discards = @discards
    @limbo_instruction.removed = @removed
    @limbo_instruction.limbo = @limbo
  end

  def test_discard
    @discard_instruction.action

    assert_equal %w(SomeCard), @discards, "discards should have a card added"
  end

  def test_remove
    @remove_instruction.action

    assert_equal %w(SomeCard), @removed, "removed should have a card added"
  end

  def test_limbo
    @limbo_instruction.action

    assert_equal %w(SomeCard), @limbo, "limbo should have a card added"
  end

  def test_no_double_dumping_in_same_pile
    @removed << "SomeCard"

    @remove_instruction.action

    assert_equal %w(SomeCard), @removed, "removed should be unchanged"
  end

  def test_no_double_dumping_across_all_piles
    @removed << "SomeCard"
    @discards.clear

    @discard_instruction.action

    assert_equal %w(SomeCard), @removed, "removed should be unchanged"
    assert_empty @discards, "a card already removed should not be discarded"
  end

  class FakeCards
    def find_by_ref(ref)
      ref
    end
  end
end
