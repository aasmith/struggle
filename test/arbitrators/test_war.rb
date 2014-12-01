require "helper"

class ArbitratorTests::WarTest < Struggle::Test

  def setup
    @arb = Arbitrators::War.new(
      player: US,
      country_names: %w(a b),
      war_instruction: Instructions::IranIraqWar
    )

    @move = EmptyMove.new(
      player: US,
      instruction: Instructions::IranIraqWar.new(
        country_name: "b"
      )
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

  def test_invalid_country
    @move.instruction.country_name = "c"

    refute @arb.accepts?(@move)
  end

  def test_invade
    assert @arb.accepts?(@move)
  end

end
