require "helper"

class ChinaCardTest < Struggle::Test
  def test_new
    c = ChinaCard.new

    assert c.holder.ussr?, "The USSR should start with the china card"
    assert c.playable?, "The china card should start flipped up (playable)"
  end

  def test_flipping
    c = ChinaCard.new

    c.use
    refute c.playable?, "China card should not be playable after use"

    c.flip_up
    assert c.playable?, "China card can be played after flipping up"
  end

  def test_transfer
    c = ChinaCard.new

    c.transfer

    assert c.holder.us?, "China card should switch owner"
    assert c.playable?, "Playable state should not change"

    c.use # no longer playable
    c.transfer

    assert c.holder.ussr?, "China card should switch owner"
    refute c.playable?, "Playable state should not change"

    c.transfer(USSR)
    assert c.holder.ussr?, "China card holder should be USSR"
  end

  def test_transfer_ready_for_play
    c = ChinaCard.new
    c.use

    c.transfer_ready_for_play

    assert c.holder.us?, "China card should switch owner"
    assert c.playable?, "China card should be playable again"

    c.use
    c.transfer_ready_for_play(US)

    assert c.holder.us?, "China card holder should be US"
    assert c.playable?, "China card should be playable again"
  end
end
