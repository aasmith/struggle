require "helper"

class ArbitratorTests::RealignmentTest < Struggle::Test

  def setup
    @arb = Arbitrators::Realignment.new(
      player: US,
      ops_counter: SimpleOpsCounter.new(1)
    )

    @move = EmptyMove.new(
      player: US,
      instruction: Instructions::Realignment.new(
        player: US,
        country_name: :notimportant
      )
    )
  end

  def test_cannot_realign_without_opponent_presence
    country = FakeCountry.new(ussr: 0, us: 1)

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = FakeDefcon.new(prevents_everything: false)

    refute @arb.accepts?(@move)
  end

  def test_cannot_realign_in_defcon_restricted_regions
    country = FakeCountry.new(ussr: 1, us: 1)

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = FakeDefcon.new(prevents_everything: true)

    refute @arb.accepts?(@move)
  end

  def test_invalid_player
    @move.instruction.player = USSR

    refute @arb.accepts?(@move)
  end

  def test_accepts_realign_with_opponent_influence_and_permissive_defcon
    country = FakeCountry.new(ussr: 1, us: 1)

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = FakeDefcon.new(prevents_everything: false)

    assert @arb.accepts?(@move)
    @arb.accept @move
    assert @arb.complete?
  end

  def test_multiple_realignments_are_counted
    country = FakeCountry.new(ussr: 4, us: 4)

    @arb.countries   = FakeCountries.new(country)
    @arb.defcon      = FakeDefcon.new(prevents_everything: false)
    @arb.ops_counter = SimpleOpsCounter.new(2)

    assert @arb.accepts?(@move)
    @arb.accept @move
    refute @arb.complete?, "Should be one more realignment allowed"

    assert @arb.accepts?(@move)
    @arb.accept @move
    assert @arb.complete?, "OpsCounter permitted two realignments"
  end

  class FakeCountry
    def initialize(ussr:, us:)
      @p = { US => us, USSR => ussr }
    end

    def presence?(player)
      @p.fetch(player) > 0
    end
  end

  class FakeOpsCounter
    def value_for_country(*)
      rand(6) + 1
    end
  end

  class FakeDefcon
    def initialize(prevents_everything:)
      @prevents_everything = prevents_everything
    end

    def affects?(*)
      @prevents_everything
    end
  end
end
