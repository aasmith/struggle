require "helper"

class TestEngine < Struggle::Test

  I = Instructions

  def test_basic_arbitrator_execution
    arbitrator = MoveAcceptor.new
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

  def test_arbitrator_stays_on_top_until_completed
    arbitrator = MultiMoveAcceptor.new
    move1 = EmptyMove.new
    move2 = EmptyMove.new

    e = Engine.new
    e.add_work_item arbitrator

    assert_equal arbitrator, e.peek, "Arbitrator should be top of stack"

    e.accept move1

    assert move1.executed?, "Move should be executed"
    refute arbitrator.complete?, "Arbitrator should still need another move"

    assert_equal arbitrator, e.peek, "Arbitrator should still be top of stack"

    e.accept move2

    assert move2.executed?, "Move should be executed"
    assert arbitrator.complete?, "Arbitrator must be complete after 2nd move"

    assert_nil e.peek, "Arbitrator should move off, stack should be empty"
  end

  def test_instructions_execute_automatically
    instruction = EmptyInstruction.new
    arbitrator1 = MoveAcceptor.new
    arbitrator2 = MoveAcceptor.new

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

    instruction1 = LambdaInstruction.new { instructions << "ex1" }
    instruction2 = LambdaInstruction.new { instructions << "ex2" }
    nested_instr = NestingInstruction.new(instruction1, instruction2)

    arbitrator = MoveAcceptor.new

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

    child = LambdaInstruction.new { instructions << "child" }

    parent = LambdaInstruction.new do
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
    instruction = EmptyInstruction.new

    e = Engine.new
    e.add_work_item instruction

    refute e.peek, "Should be nothing left to accept"

    assert instruction.complete?, "Should execute automatically"

    refute e.peek, "Should be nothing left to accept"
  end

  def test_arbitrators_can_return_instructions
    instructions = []

    instruction1 = LambdaInstruction.new { instructions << "ex1" }
    instruction2 = LambdaInstruction.new { instructions << "ex2" }
    nested_instr = NestingInstruction.new(instruction1, instruction2)

    arbitrator = MoveAcceptor.new

    move = Move.new
    move.player = USSR
    move.instruction = nested_instr

    e = Engine.new
    e.add_work_item arbitrator

    assert_equal arbitrator, e.peek, "Arbitrator should be waiting for a move"

    refute nested_instr.complete?, "Arbitrator should not execute instruction"
    refute instruction1.complete?, "Arbitrator should not execute instruction"
    refute instruction2.complete?, "Arbitrator should not execute instruction"

    e.accept move

    assert nested_instr.complete?, "Arbitrator should execute given a move"
    assert instruction1.complete?, "Arbitrator should execute given a move"
    assert instruction2.complete?, "Arbitrator should execute given a move"

    assert_equal %w(ex1 ex2), instructions, "Instructions should be in order"

    assert arbitrator.complete?
  end

  ### MODIFIERS

  # Engine stack, with one stack modifier:
  #
  # [arbitrator]
  #
  # Add a move, the modifier fires, and the stack becomes
  #
  # [mod-new-instr, arbitrator(with stashed move)]
  #
  # Execution should still continue until the stack becomes
  #
  # [nested-instr]
  #
  # [instruction1, instruction2]
  #
  # []
  #
  def test_resumed_arbitrators_can_return_instructions
    instructions = []

    instruction1 = LambdaInstruction.new { instructions << "ex1" }
    instruction2 = LambdaInstruction.new { instructions << "ex2" }
    nested_instr = NestingInstruction.new(instruction1, instruction2)

    arbitrator = MoveAcceptor.new

    move = Move.new
    move.player = USSR
    move.instruction = nested_instr

    new_instruction = EmptyInstruction.new

    mod = StackModifier.new(new_instruction)

    e = Engine.new
    e.add_stack_modifier mod
    e.add_work_item arbitrator

    e.accept move

    assert_nil e.peek!, "Engine should be empty"

    assert new_instruction.complete?

    assert nested_instr.complete?
    assert instruction1.complete?
    assert instruction2.complete?

    assert move.executed?

    assert_equal %w(ex1 ex2), instructions, "Instructions should be in order"

    assert arbitrator.complete?, "Original arbitrator should be complete"

  end

  def test_permission_modifier_denies_move
    arbitrator = MoveAcceptor.new
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

  def test_permission_modifier_skips_instruction
    instruction = EmptyInstruction.new

    e = Engine.new
    e.add_permission_modifier NegativePermissionModifier.new

    e.add_work_item instruction

    refute e.peek, "Should be nothing left"

    refute instruction.complete?, "Should never execute"
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
    orig_arbitrator = MoveAcceptor.new label: :orig
    orig_move = EmptyMove.new label: :orig

    new_instruction = EmptyInstruction.new
    new_arbitrator = MoveAcceptor.new label: :new

    mod = StackModifier.new(new_instruction, new_arbitrator)

    new_move = EmptyMove.new label: :new

    e = Engine.new
    e.add_stack_modifier mod
    e.add_work_item orig_arbitrator

    e.accept orig_move

    refute orig_arbitrator.complete?,
      "Original arbitrator should not be complete"

    refute orig_move.executed?,
      "Original move should not be executed"

    assert new_instruction.complete?,
      "Newly inserted instruction should be complete"

    assert_equal new_arbitrator, e.peek,
      "Newly inserted arbitrator should be top of stack"

    e.accept new_move

    assert new_instruction.complete?, "New instruction should be complete"
    assert new_arbitrator.complete?, "New move should complete new arbitrator"
    assert new_move.executed?, "New move should be executed"

    assert orig_arbitrator.complete?, "Original arb should be complete"
    assert orig_move.executed?, "Original move should be executed"

    refute e.peek, "Should be nothing left in stack"
  end

  def test_work_items_are_injected
    item = EmptyInstruction.new
    fake_injector = FakeInjector.new

    e = Engine.new
    e.injector = fake_injector

    e.add_work_item item

    e.accept nil

    assert fake_injector.injected?(item), "Item was not passed to the injector"
  end

  class MoveAcceptor < MoveArbitrator
    def initialize(**args)
      @label = args.delete(:label)
      super()
    end

    def accepts?(move) move end # true if move is not nil
  end

  # Only marks itself as complete once it has accepted two moves.
  class MultiMoveAcceptor < MoveArbitrator
    def initialize(**)
      super

      @num_accepted = 0
    end

    def accepts?(move)
      @num_accepted += 1 if move
    end

    def after_execute(move)
      complete if @num_accepted >= 2
    end
  end

  class LambdaInstruction < Instruction
    def initialize(**_, &block)
      super()

      @block = block
    end

    def action
      @block.call
    end
  end

  class NestingInstruction < Instruction
    def initialize(*instructions)
      super()

      unless instructions.all? { |i| WorkItem === i }
        bad = instructions.reject { |i| i.is_a? WorkItem }
        raise "Bad list items: #{bad.inspect}"
      end

      @instructions = instructions
    end

    def action
      @instructions
    end
  end

  ##
  # Always says no to every instruction or move.
  #
  # Used for testing.
  #
  class NegativePermissionModifier
    def allows?(instruction_or_move)
      false
    end
  end
end

