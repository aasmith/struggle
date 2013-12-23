require "helper"

class PhasingPlayerTest < Struggle::Test

  def test_new
    pp = PhasingPlayer.new

    assert pp.ussr?, "Should initialize to USSR"
  end

  def test_delegates
    pp = PhasingPlayer.new
    assert pp.ussr?, "Should delegate"

    pp.player = US
    assert pp.us?, "Should delegate to updated player"
  end

end
