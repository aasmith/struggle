require "helper"

class TestEngine < Struggle::Test

  I = Instructions
  A = Arbitrators

  def test_basic_arbitrator_execution
    arbitrator = A::MoveAcceptor.new
    move = EmptyMove.new

    e = Engine.new
    e.add_work_item arbitrator

    e.accept move

    assert arbitrator.complete?, "Provided move should satisfy the arbitrator"
    assert move.executed?, "Move should be executed after approval"

    refute e.peek, "Should be nothing left to accept"
    # assert no more requirements
    # assert history has been filled
  end

  def test_instructions_execute_automatically
    instruction = I::EmptyInstruction.new
    arbitrator1 = A::MoveAcceptor.new
    arbitrator2 = A::MoveAcceptor.new

    move1 = EmptyMove.new
    move2 = EmptyMove.new

    e = Engine.new
    e.add_work_item arbitrator1, instruction, arbitrator2

    e.accept move1

    assert arbitrator1.complete?, "Should be satisfied by provided move"
    assert instruction.complete?, "Instruction should execute automatically"
    refute arbitrator2.complete?, "Second arbitrator should not be called yet"
    assert move1.executed?,       "Should be executed by first arbitrator"

    e.accept move2

    assert arbitrator2.complete?, "Second arbitrator should accept second move"
    assert move2.executed?, "Should be executed by second arbitrator"

    refute e.peek, "Should be nothing left to accept"
  end

  def test_nested_executables_execute_automatically
    instructions = []

    instruction1 = I::LambdaInstruction.new { instructions << "ex1" }
    instruction2 = I::LambdaInstruction.new { instructions << "ex2" }
    nested_instr = I::NestingInstruction.new(instruction1, instruction2)

    arbitrator = A::MoveAcceptor.new

    move = EmptyMove.new

    e = Engine.new
    e.add_work_item arbitrator, nested_instr

    e.accept move

    assert move.executed?, "Should be executed by arbitrator"

    assert arbitrator.complete?, "Should be satisfied by move provided"
    assert instruction1.complete?, "Should execute automatically"
    assert instruction2.complete?, "Should execute automatically"
    assert nested_instr.complete?, "Should be satifisfied by children"

    assert_equal %w(ex1 ex2), instructions, "Instructions should be in order"

    refute e.peek, "Should be nothing left to accept"
  end

  def test_nested_executables_dont_need_to_return_an_array
    instructions = []

    child = I::LambdaInstruction.new { instructions << "child" }

    parent = I::LambdaInstruction.new do
      instructions << "parent"
      child # return a single instruction -- not an array
    end

    e = Engine.new
    e.add_work_item parent

    e.accept nil

    assert parent.complete?
    assert child.complete?

    assert_equal %w(parent child), instructions
  end

  def test_peek_progresses_execution
    instruction = I::EmptyInstruction.new

    e = Engine.new
    e.add_work_item instruction

    refute e.peek, "Should be nothing left to accept"

    assert instruction.complete?, "Should execute automatically"

    refute e.peek, "Should be nothing left to accept"
  end

  ### MODIFIERS

  def test_permission_modifier_denies_move
    arbitrator = A::MoveAcceptor.new
    move = EmptyMove.new

    e = Engine.new
    e.add_permission_modifier NegativePermissionModifier.new

    e.add_work_item arbitrator

    e.accept move

    assert arbitrator.accepts?(move), "Expectation should still accept move"

    refute arbitrator.complete?, "arbitrator should not be satisfied"
    refute move.executed?, "Move should not be executed"

    assert_equal arbitrator, e.peek,
      "arbitrator should still be waiting for a move allowed by modifiers"
  end

  # Engine stack, with one stack modifier:
  #
  # [orig-arb]
  #
  # Upon move, the modifier fires and the stack becomes
  #
  # [new-instr, new-arb, orig-arb]
  #
  # This game will now need one extra move to empty the stack.
  #
  def test_stack_modifier_adds_items_to_stack
    orig_arbitrator = A::MoveAcceptor.new
    orig_move = EmptyMove.new

    new_instruction = I::EmptyInstruction.new
    new_arbitrator = A::MoveAcceptor.new

    mod = StackModifier.new(new_instruction, new_arbitrator)

    new_move = EmptyMove.new

    e = Engine.new
    e.add_stack_modifier mod
    e.add_work_item orig_arbitrator

    e.accept orig_move

    refute orig_arbitrator.complete?,
      "Original arbitrator should not be complete"

    refute orig_move.executed?,
      "Original move should not be executed"

    assert_equal new_instruction, e.peek!,
      "Newly inserted instruction should be top of stack"

    e.accept new_move

    assert new_instruction.complete?, "New instruction should be complete"
    assert new_arbitrator.complete?, "New move should complete new arbitrator"
    assert new_move.executed?, "New move should be executed"

    assert orig_arbitrator.complete?, "Original arb should be complete"
    assert orig_move.executed?, "Original move should be executed"

    refute e.peek, "Should be nothing left in stack"
  end

  def xtest_modifier_lifecycle
  end

  def test_work_items_are_injected
    item = I::EmptyInstruction.new

    fake_injector = Minitest::Mock.new.expect(:inject, nil, [item])

    e = Engine.new
    e.injector = fake_injector

    e.add_work_item item

    e.accept nil

    fake_injector.verify
  end

  # This test makes use of an unrealistic/naive way of managing score.
  # ScoreModifiers should probably be stored with and modify a centralized
  # ScoreResolver component.
  def xtest_score_modification
    arbitrator = MoveAcceptor.new
    arbitrator.derp

    move = AmountMove.new
    move.amount = 2

    e = Engine.new
    e.add_score_modifier NegativeScoreModifier.new
    e.add_expectations exp

    e.accept move

    assert exp.satisfied?
    assert move.executed?

    assert_equal 1, move.amount, "Amount should be reduced by modifier"
  end

  def xtest_score_modification_making_move_invalid
    exp = AmountMoveExpectation.new
    exp.amount = 2

    move = AmountMove.new
    move.amount = 2

    e = Engine.new
    e.add_score_modifier NegativeScoreModifier.new
    e.add_expectations exp

    e.accept move

    refute exp.allows?(move), "Move should now have an unacceptable amount"
    refute exp.satisfied?, "Expecation should not be satisified"
    refute move.executed?, "Modified move should not be executed"

    assert_equal 1, move.amount, "Amount should be reduced by modifier"
  end

end

