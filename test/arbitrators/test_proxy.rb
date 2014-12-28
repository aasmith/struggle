require "helper"

class ArbitratorTests::ProxyTest < Struggle::Test

  def setup
    @move = EmptyMove.new(
      player: US,
      instruction: FakeInstruction.new
    )

    @noop = EmptyMove.new(
      player: US,
      instruction: Instructions::Noop.new
    )
  end

  def setup_arb(*arbitrators)
    @arb = Arbitrators::Proxy.new(
       player: US,
      choices: arbitrators
    )
  end

  def setup_all_to_accept
    setup_arb(
      AcceptingArbitrator.new,
      AcceptingArbitrator.new
    )
  end

  def setup_all_to_reject
    setup_arb(
      RejectingArbitrator.new,
      RejectingArbitrator.new
    )
  end

  def setup_one_to_accept
    setup_arb(
      RejectingArbitrator.new,
      @acceptor = AcceptingArbitrator.new
    )
  end

  def test_rejects_if_no_suitable_move
    setup_all_to_reject
    refute @arb.accepts?(@move)
  end

  def test_rejects_if_move_is_ambiguous
    setup_all_to_accept
    refute @arb.accepts?(@move)
  end

  def test_noop_completes
    setup_all_to_reject
    assert @arb.accepts?(@noop)

    @arb.accept @noop
    assert @arb.complete?
  end

  def test_invalid_player_cannot_noop
    setup_all_to_reject
    @noop.player = USSR

    refute @arb.accepts?(@noop)
  end

  def test_accepts_when_only_one_arbitrator_accepts
    setup_one_to_accept
    assert @arb.accepts?(@move)
  end

  def test_before_execute_called
    setup_one_to_accept
    assert @arb.accepts?(@move)

    @arb.before_execute(@move)
    assert_equal @move, @acceptor.state[:before_execute]
  end

  def test_after_execute_called
    setup_one_to_accept
    assert @arb.accepts?(@move)

    @arb.after_execute(@move)
    assert_equal @move, @acceptor.state[:after_execute]
  end

  def test_complete_occurs_on_proxy_and_target
    setup_one_to_accept
    assert @arb.accepts?(@move)

    @arb.accept @move

    assert @arb.complete?
    assert @acceptor.complete?
  end

  class VerboseArbitrator < MoveArbitrator
    def initialize
      super

      @state = {}
    end

    def before_execute(move)
      @state[:before_execute] = move
    end

    def after_execute(move)
      @state[:after_execute] = move
      complete
    end

    def state
      @state
    end
  end

  class AcceptingArbitrator < VerboseArbitrator
    def accepts?(*)
      true
    end
  end

  class RejectingArbitrator < VerboseArbitrator
    def accepts?(*)
      false
    end
  end

  # Something that won't match a Noop, but still does nothing
  FakeInstruction = Class.new(Instruction)
end
