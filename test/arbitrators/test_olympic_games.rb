require "helper"

class ArbitratorTests::OlympicGamesTest < Struggle::Test

  def setup
    @arb = Arbitrators::OlympicGames.new(
      player: USSR
    )

    @move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::SupportOlympicGames.new
    )
  end

  def test_accepts_enter
    assert @arb.accepts?(@move)
  end

  def test_accepts_boycott
    @move.instruction = Instructions::BoycottOlympicGames.new
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
    @move.instruction = Instructions::Noop.new
    refute @arb.accepts?(@move)
  end

end
