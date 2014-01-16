require "helper"

class InstructionTests::DisposeCurrentCardsTest < Struggle::Test

  def test_surrenders_china_card
    instruction = Instructions::DisposeCurrentCards.new
    instruction.current_cards = [FakeChinaCard.new]

    instructions = instruction.action

    assert_equal 2, instructions.size

    assert_kind_of Instructions::RemoveCurrentCard,  instructions[0]
    assert_kind_of Instructions::SurrenderChinaCard, instructions[1]
  end

  def test_discards_card
    instruction = Instructions::DisposeCurrentCards.new
    instruction.current_cards = [FakeNotChinaCard.new]

    instructions = instruction.action

    assert_equal 2, instructions.size

    assert_kind_of Instructions::RemoveCurrentCard, instructions[0]
    assert_kind_of Instructions::Discard,           instructions[1]
  end

  class FakeChinaCard
    def ref
      "cc"
    end

    def china_card?
      true
    end
  end

  class FakeNotChinaCard
    def ref
      "ncc"
    end

    def china_card?
      false
    end
  end

end
