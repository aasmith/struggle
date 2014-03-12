require "helper"

class ArbitratorTests::RemoveInfluenceTest < Struggle::Test

  def setup
    @arbitrator = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: US,
      country_names: [:a, :b],
      total_influence: 6
    )

    @limit_arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: US,
      country_names: %i(a b c d e),
      total_influence: 4,
      limit_per_country: 2
    )

    @total_arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: US,
      country_names: %i(a b c d e),
      total_influence: 4,
      total_countries: 2
    )

    # US -- a -- b -- c -- d -- e -- USSR
    five_countries = [
      ["A Country", 1, false, "Region", ["B Country"], "US"],
      ["B Country", 1, false, "Region", ["A Country", "C Country"]],
      ["C Country", 1, false, "Region", ["B Country", "D Country"]],
      ["D Country", 1, false, "Region", ["C Country", "E Country"]],
      ["E Country", 1, false, "Region", ["D Country"], "USSR"],
    ]

    @five_countries = Countries.new(five_countries)

    @arbitrator.countries = @five_countries
    @limit_arb.countries  = @five_countries
    @total_arb.countries  = @five_countries
  end

  def test_accepts_move
    populate_wildy

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 6
      )
    )

    move.instruction.countries = @five_countries

    assert @arbitrator.incomplete?,
      "Should be incomplete because no moves have been provided"

    assert_equal 6, @arbitrator.remaining_influence,
      "Should have all influence still remaining to place"

    assert @arbitrator.accepts?(move),
      "The move should be valid to accept"

    @arbitrator.accept(move)

    assert_equal 0, @arbitrator.remaining_influence,
      "All influence should be placed"

    assert @arbitrator.complete?,
      "The move should entirely satisfy the arbitrator"
  end

  def test_fractional_move
    populate_wildy

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 4
      )
    )

    move.instruction.countries = @five_countries

    @arbitrator.accept(move)

    assert @arbitrator.incomplete?,
      "Should be incomplete because the move does not entirely satisfy"

    assert_equal 2, @arbitrator.remaining_influence,
      "Some influence should be placed"
  end

  def test_invalid_country
    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :nonexistant,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The country should be invalid"

    move.instruction.country_name = :a
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_influence
    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :a,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The influence should be invalid"

    move.instruction.influence = US
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_amount
    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 7
      )
    )

    refute @arbitrator.accepts?(move), "The amount should be too much"

    move.instruction.amount = 1
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_player
    move = Move.new(
      player: US,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The player should be invalid"

    move.player = USSR
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_class
    move = Move.new(
      player: USSR,
      instruction: Instructions::AddInfluence.new(
        influence: US,
        country_name: :a,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "Instruction class should be invalid"

    move.instruction = Instructions::RemoveInfluence.new(
      influence: US,
      country_name: :a,
      amount: 6
    )

    assert @arbitrator.accepts?(move)
  end

  def test_limit_per_country
    populate_wildy

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 3
      )
    )

    refute @limit_arb.accepts?(move), "Places too much influence"

    move.instruction.countries = @five_countries
    move.instruction.amount = 2
    assert @limit_arb.accepts?(move)

    @limit_arb.accept(move)

    refute @limit_arb.accepts?(move), "No more influence allowed in 'a'"
  end

  def test_total_countries
    populate_wildy

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 1
      )
    )

    move.instruction.countries = @five_countries

    assert @total_arb.accepts?(move)
    @total_arb.accept move

    move.instruction.country_name = :b

    assert @total_arb.accepts?(move)
    @total_arb.accept move

    move.instruction.country_name = :c

    refute @total_arb.accepts?(move), "Too many countries influenced"
  end

  # scenarios for when no more influence can be removed, even though
  # the maximum limit set by total_influence has not been reached:
  #
  # Scenario A
  #
  # total influence: 2
  #
  # country a: 1
  #
  # --
  #
  # Scenario B
  #
  # total influence: 2, limit per: 1
  #
  # country a: 2
  #
  # --
  #
  # Scenario C
  #
  # total influence: 3, limit per: 2, total countries: 2
  #
  # country a: 1
  # country b: 1
  # country c: 1

  def test_all_influence_removed_prematurely_scenario_a
    arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: US,
      country_names: [:a, :b, :c, :d],
      total_influence: 2
    )

    arb.countries = @five_countries

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 1
      )
    )

    move.instruction.countries = @five_countries

    @five_countries.find(:a).add_influence(US, 1)

    assert arb.accepts?(move)
    arb.accept(move)

    assert arb.all_possible_influence_removed?
    assert arb.complete?
  end

  def test_all_influence_removed_prematurely_scenario_b
    arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: US,
      country_names: [:a, :b, :c, :d],
      total_influence: 2,
      limit_per_country: 1
    )

    arb.countries = @five_countries

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 1
      )
    )

    move.instruction.countries = @five_countries

    @five_countries.find(:a).add_influence(US, 2)

    assert arb.accepts?(move)
    arb.accept(move)

    assert arb.all_possible_influence_removed?
    assert arb.complete?
  end

  def test_all_influence_removed_prematurely_scenario_c
    arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: US,
      country_names: [:a, :b, :c, :d],
      total_influence: 3,
      limit_per_country: 1,
      total_countries: 2
    )

    arb.countries = @five_countries

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :a,
        amount: 1
      )
    )

    move.instruction.countries = @five_countries

    @five_countries.find(:a).add_influence(US, 1)
    @five_countries.find(:b).add_influence(US, 1)
    @five_countries.find(:c).add_influence(US, 1)

    assert arb.accepts?(move)
    arb.accept(move)

    refute arb.all_possible_influence_removed?
    refute arb.complete?

    move = Move.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :b,
        amount: 1
      )
    )

    move.instruction.countries = @five_countries

    assert arb.accepts?(move)
    arb.accept(move)

    assert arb.all_possible_influence_removed?
    assert arb.complete?
  end

  def populate_wildy
    @five_countries.find(:a).add_influence(US,   10)
    @five_countries.find(:b).add_influence(US,   10)
    @five_countries.find(:c).add_influence(US,   10)
    @five_countries.find(:d).add_influence(US,   10)
    @five_countries.find(:e).add_influence(US,   10)
    @five_countries.find(:a).add_influence(USSR, 10)
    @five_countries.find(:b).add_influence(USSR, 10)
    @five_countries.find(:c).add_influence(USSR, 10)
    @five_countries.find(:d).add_influence(USSR, 10)
    @five_countries.find(:e).add_influence(USSR, 10)
  end
end
