require "helper"

class InstructionTests::CardDumpersTest < Struggle::Test

  def setup
    @discards = []
    @removed = []
    @limbo = []

    @card = Card.new(name: "SomeCard", ref: "SomeCard")

    @discard_instruction = Instructions::Discard.new(card_ref: "SomeCard")
    @discard_instruction.cards = FakeCards.new(@card)

    @discard_instruction.discards = @discards
    @discard_instruction.removed = @removed
    @discard_instruction.limbo = @limbo

    @remove_instruction = Instructions::Remove.new(card_ref: "SomeCard")
    @remove_instruction.cards = FakeCards.new(@card)

    @remove_instruction.discards = @discards
    @remove_instruction.removed = @removed
    @remove_instruction.limbo = @limbo

    @limbo_instruction = Instructions::Limbo.new(card_ref: "SomeCard")
    @limbo_instruction.cards = FakeCards.new(@card)

    @limbo_instruction.discards = @discards
    @limbo_instruction.removed = @removed
    @limbo_instruction.limbo = @limbo
  end

  def test_discard
    @discard_instruction.action

    assert_equal [@card], @discards, "discards should have a card added"
  end

  def test_remove
    @remove_instruction.action

    assert_equal [@card], @removed, "removed should have a card added"
  end

  def test_limbo
    @limbo_instruction.action

    assert_equal [@card], @limbo, "limbo should have a card added"
  end

  def test_no_double_dumping_in_same_pile
    @removed << @card

    @remove_instruction.action

    assert_equal [@card], @removed, "removed should be unchanged"
  end

  def test_no_double_dumping_across_all_piles
    @removed << @card
    @discards.clear

    @discard_instruction.action

    assert_equal [@card], @removed, "removed should be unchanged"
    assert_empty @discards, "a card already removed should not be discarded"
  end

  class FakeCards
    def initialize(card)
      @card = card
    end

    def find_by_ref(ref)
      @card
    end
  end
end
