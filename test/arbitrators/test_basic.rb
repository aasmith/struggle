require "helper"

class ArbitratorTests::BasicTest < Struggle::Test

  def setup
    @arb = Arbitrators::Basic.new(
      player: USSR,
      allows: [Instructions::Noop]
    )

    @move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::Noop.new
    )
  end

  def test_accepts_enter
    assert @arb.accepts?(@move)
  end

  def test_complete_after_move
    @arb.accept @move
    assert @arb.complete?
  end

  def test_invalid_player
    @move.player = US
    refute @arb.accepts?(@move)
  end

  def test_invalid_instruction
    @move.instruction = Instructions::Fake.new
    refute @arb.accepts?(@move)
  end

  Instructions::Fake = Class.new(Instructions::Noop)

end
