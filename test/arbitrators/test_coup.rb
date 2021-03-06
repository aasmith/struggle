require "helper"

class ArbitratorTests::CoupTest < Struggle::Test

  def setup
    @arb = Arbitrators::Coup.new(
      player: US,
      ops_counter: FakeOpsCounter.new
    )

    @move = EmptyMove.new(
      player: US,
      instruction: Instructions::Coup.new(
        player: US,
        country_name: :notimportant
      )
    )
  end

  def test_cannot_coup_without_opponent_presence
    country = FakeCountry.new(ussr: 0, us: 1)

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = BlanketDefcon.new(prevents_everything: false)

    refute @arb.accepts?(@move)
  end

  def test_cannot_coup_in_defcon_restricted_regions
    country = FakeCountry.new(ussr: 1, us: 1)

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = BlanketDefcon.new(prevents_everything: true)

    refute @arb.accepts?(@move)
  end

  def test_invalid_player
    @move.instruction.player = USSR

    refute @arb.accepts?(@move)
  end

  def test_invalid_country
    @arb.countries = FakeCountries.new
    @arb.country_names = %w(aaa bbb)
    @move.instruction.country_name = "ccc"

    refute @arb.accepts?(@move)
  end

  def test_valid_country
    country = FakeCountry.new(ussr: 1, us: 1)

    @arb.country_names = %w(aaa bbb ccc)
    @move.instruction.country_name = "ccc"

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = BlanketDefcon.new(prevents_everything: false)

    assert @arb.accepts?(@move)
    @arb.accept @move
    assert @arb.complete?
  end

  def test_accepts_coup_with_opponent_influence_and_permissive_defcon
    country = FakeCountry.new(ussr: 1, us: 1)

    @arb.countries = FakeCountries.new(country)
    @arb.defcon    = BlanketDefcon.new(prevents_everything: false)

    assert @arb.accepts?(@move)
    @arb.accept @move
    assert @arb.complete?
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
end
