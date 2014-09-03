require "helper"

class InstructionTests::WarOutcomeFactoryTest < Struggle::Test

  def test_build_victory
    win = Instructions::WarOutcomeFactory.build(
        player: :bob,
        country_name: :somewhere,
        victory: true,
        military_ops: 2,
        vp_award: 1
    )

    assert_instance_of Instructions::WarVictory, win
    assert_equal :bob, win.player
    assert_equal :somewhere, win.country_name
    assert_equal 2, win.military_ops
    assert_equal 1, win.vp_award
  end

  def test_build_loss
    loss = Instructions::WarOutcomeFactory.build(
        player: :bob,
        country_name: :somewhere,
        victory: false,
        military_ops: 2,
        vp_award: 1
    )

    assert_instance_of Instructions::WarLoss, loss
    assert_equal :bob, loss.player
    assert_equal :somewhere, loss.country_name
    assert_equal 2, loss.military_ops
  end

  def test_initialize_fails
    assert_raises ArgumentError do
      Instructions::WarOutcomeFactory.new
    end
  end
end
