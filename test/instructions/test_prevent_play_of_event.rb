require "helper"

class InstructionTests::PreventPlayOfEventTest < Struggle::Test

  def test_adds_to_engine
    i = Instructions::PreventPlayOfEvent.new(
      card_ref: "Blockade",
        reason: "Testing"
    )

    engine = Engine.new

    i.engine = engine
    i.cards = TEST_CARDS

    i.action

    preventer, * = engine.permission_modifiers

    assert_equal 1, engine.permission_modifiers.size
    assert_equal "Blockade", preventer.card_ref
    assert_equal "Testing",  preventer.reason
  end

end
