require "helper"

class ArbitratorTests::FreeMoveTest < Struggle::Test

  def setup
    @arb = Arbitrators::FreeMove.new(
      player: US,
         ops: 4
    )

    @move = EmptyMove.new(
      player: US,
      instruction: Instructions::FreeMove.new(
           player: US,
        operation: :coup
      )
    )

    @arb.observers = Observers.new([])
  end

  def test_invalid_player
    @move.instruction.player = USSR

    refute @arb.accepts?(@move)
  end

  def test_invalid_instruction
    @move.instruction = Class.new

    refute @arb.accepts?(@move)
  end

  def test_accepts_free_move
    assert @arb.accepts?(@move)
    @arb.accept @move
    assert @arb.complete?
  end

  def test_accepts_noop
    @move.instruction = Instructions::Noop.new

    assert @arb.accepts?(@move)
    @arb.accept @move
    assert @arb.complete?
  end

  def test_adds_ops_counter
    @arb.accept @move

    counter = @move.instruction.ops_counter

    assert counter, "An ops counter should be provided for execution"
    assert_equal 4, counter.base_value, "Ops counter should be untouched"
  end

end
