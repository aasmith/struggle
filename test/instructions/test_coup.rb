require "helper"

class CoupTest < Struggle::Test

  I = Instructions

  def test_successful_battleground_coup_degrades_defcon
    successful_coup battleground_country

    degrade, others = @instructions.grep I::DegradeDefcon

    assert_nil others, "Should only be one DegradeDefcon"
    assert_instance_of I::Coup, degrade.cause
  end

  def test_failed_battleground_coup_degrades_defcon
    failed_coup battleground_country

    degrade, others = @instructions.grep I::DegradeDefcon

    assert_nil others, "Should only be one DegradeDefcon"
    assert_instance_of I::Coup, degrade.cause
  end

  def test_successful_non_battleground_coup_doesnt_degrade_defcon
    successful_coup

    refute_includes @instructions.map(&:class), I::DegradeDefcon
  end

  def test_failed_non_battleground_coup_doesnt_degrade_defcon
    failed_coup

    refute_includes @instructions.map(&:class), I::DegradeDefcon
  end

  def test_successful_coup_advances_military_ops
    successful_coup

    increment, others = @instructions.grep I::IncrementMilitaryOps

    assert_nil others, "Should only be one IncrementMilitaryOps"
    assert_equal US, increment.player
    assert_equal 4, increment.amount
  end

  def test_failed_coup_advances_military_ops
    failed_coup

    increment, others = @instructions.grep I::IncrementMilitaryOps

    assert_nil others, "Should only be one IncrementMilitaryOps"
    assert_equal US, increment.player
    assert_equal 1, increment.amount
  end

  def test_successful_coup_swings_influence
    successful_coup

    # The contents and details of actual swings are tested separately.
    # See test_swing_*.
    assert_includes @instructions.map(&:class), I::RemoveInfluence
  end

  def test_failed_coup_doesnt_swing_influence
    failed_coup

    refute_includes @instructions.map(&:class), I::RemoveInfluence
    refute_includes @instructions.map(&:class), I::AddInfluence
  end

  def test_swing_influence_rejects_zero_influence
    ex = assert_raises ArgumentError do
      scenario us: 0, ussr: 3, swing: 0
    end

    assert_match "Influence must be >= 1", ex.message
  end

  def test_swing_influence_rejects_negative_influence
    ex = assert_raises ArgumentError do
      scenario us: 0, ussr: 3, swing: -1
    end

    assert_match "Influence must be >= 1", ex.message
  end

  def test_swing_influence_needs_opponent_influence
    ex = assert_raises ArgumentError do
      scenario us: 0, ussr: 0, swing: 2
    end

    assert_match %r<Opponent USSR not in>, ex.message
  end

  def test_swing_influence_reduces_opponent_influence
    scenario us: 0, ussr: 3, swing: 2

    remove, _ = @instructions

    assert_equal 1, @instructions.size, "Should be a remove only"

    assert_instance_of Instructions::RemoveInfluence, remove
    assert_equal @country.name, remove.country_name
    assert_equal 2, remove.amount
  end

  def test_swing_influence_removes_all_opponent_influence
    scenario us: 0, ussr: 3, swing: 3

    remove, _ = @instructions

    assert_equal 1, @instructions.size, "Should be a remove only"

    assert_instance_of Instructions::RemoveInfluence, remove
    assert_equal @country.name, remove.country_name
    assert_equal 3, remove.amount
  end

  def test_swing_influence_removes_all_opposition_and_adds_player_influence
    scenario us: 0, ussr: 3, swing: 4

    remove, add = @instructions

    assert_equal 2, @instructions.size, "Should be a remove and an add"

    assert_instance_of Instructions::RemoveInfluence, remove
    assert_equal @country.name, remove.country_name
    assert_equal USSR, remove.influence
    assert_equal 3, remove.amount

    assert_instance_of Instructions::AddInfluence, add
    assert_equal @country.name, add.country_name
    assert_equal US, add.influence
    assert_equal 1, add.amount
  end

  # Assuming a coup by the US in a country that has influence as defined
  # by the method args +us+ and +ussr+.
  #
  # Swing is how much of a swing there should be from the USSR to the US.

  def scenario(us:, ussr:, swing:, country: country())

    country.add_influence(US,   us)
    country.add_influence(USSR, ussr)

    coup = Instructions::Coup.new(
      player: US,
      country_name: "Foo"
    )

    coup.countries = FakeCountries.new(country)
    coup.observers = Observers.new([])

    @country = country

    @instructions =
      coup.swing_influence(country: country, player: US, amount: swing)
  end

  def successful_coup(country = country())

    country.add_influence(US,   0)
    country.add_influence(USSR, 4)

    coup = Instructions::Coup.new(
      player: US,
      country_name: "Foo"
    )

    coup.countries = FakeCountries.new(country)
    coup.observers = Observers.new([])
    coup.ops_value = 4
    coup.die       = OneSidedDie.new(6)

    @instructions = coup.action
  end

  def failed_coup(country = country())

    country.add_influence(US,   0)
    country.add_influence(USSR, 4)

    coup = Instructions::Coup.new(
      player: US,
      country_name: "Foo"
    )

    coup.countries = FakeCountries.new(country)
    coup.observers = Observers.new([])
    coup.ops_value = 1
    coup.die       = OneSidedDie.new(1)

    @instructions = coup.action
  end

  def country(battleground: false)
    Country.new("Foo", 3, battleground, [], [])
  end

  def battleground_country
    country(battleground: true)
  end

end
