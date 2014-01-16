require "helper"

class InstructionTests::DisposeTest < Struggle::Test

  def test_surrenders_china_card
    instruction = Instructions::Dispose.new(card_ref: "TheChinaCard")
    instruction.cards = AlwaysChinaCards.new

    instructions = instruction.action

    assert_equal 2, instructions.size

    assert_kind_of Instructions::RemoveCurrentCard,  instructions[0]
    assert_kind_of Instructions::SurrenderChinaCard, instructions[1]
  end

  def test_discards_card
    instruction = Instructions::Dispose.new(card_ref: "NotTheChinaCard")
    instruction.cards = NeverChinaCards.new

    instructions = instruction.action

    assert_equal 2, instructions.size

    assert_kind_of Instructions::RemoveCurrentCard, instructions[0]
    assert_kind_of Instructions::Discard,           instructions[1]
  end

  class AlwaysChinaCards
    def find_by_ref(_)
      Struct.new(:china_card?).new(true)
    end
  end

  class NeverChinaCards
    def find_by_ref(_)
      Struct.new(:china_card?).new(false)
    end
  end

end
