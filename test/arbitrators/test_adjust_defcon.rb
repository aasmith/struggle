require "helper"

class ArbitratorTests::AdjustDefconTest < Struggle::Test

  def setup
    @arb = Arbitrators::AdjustDefcon.new(
      player: US
    )

    @move = EmptyMove.new(
      player: US,
      instruction: Instructions::DegradeDefcon.new(cause: nil)
    )
  end

  def test_invalid_player
    @move.player = USSR

    refute @arb.accepts?(@move)
  end

  def test_invalid_instruction
    @move.instruction = Class.new

    refute @arb.accepts?(@move)
  end

  def test_invalid_amount
    @move.instruction = Instructions::ImproveDefcon.new(amount: 2)

    refute @arb.accepts?(@move)
  end

  def test_improve
    @move.instruction = Instructions::ImproveDefcon.new(amount: 1)

    assert @arb.accepts?(@move)
  end

  def test_degrade
    assert @arb.accepts?(@move)
  end

  def test_noop
    @move.instruction = Instructions::Noop.new

    assert @arb.accepts?(@move)
  end

end
