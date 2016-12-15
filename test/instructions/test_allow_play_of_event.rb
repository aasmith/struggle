require "helper"

class InstructionTests::AllowPlayOfEvent < Struggle::Test

  def setup
    @instruction = Instructions::AllowPlayOfEvent.new(
      card_ref: "Blockade"
    )

    @engine = Engine.new

    @instruction.engine = @engine
    @instruction.cards = TEST_CARDS
  end

  def test_removes_existing_permission_modifier

    @engine.add_permission_modifier(
      Modifiers::Permission::CardPlayEventPreventer.new(
        card_ref: "Blockade",
        reason: "Testing"
      )
    )

    @instruction.action

    assert_empty @engine.permission_modifiers, "Modifier should be removed"
  end

  def test_no_op_when_no_permission_modifier_found
    @instruction.action

    assert_empty @engine.permission_modifiers, "Modifiers should not change"
  end

end
