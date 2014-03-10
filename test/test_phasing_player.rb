require "helper"

class PhasingPlayerTest < Struggle::Test

  def test_new
    pp = PhasingPlayer.new

    assert pp.player.ussr?, "Should initialize to USSR"
  end

  def test_switch_player
    pp = PhasingPlayer.new

    assert pp.player = US

    assert pp.player.us?, "Should update player"
  end

end
