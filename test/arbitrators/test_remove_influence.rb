require "helper"

class ArbitratorTests::RemoveInfluenceTest < Struggle::Test

  def setup
    @arbitrator = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: USSR,
      country_names: [:east_germany, :west_germany],
      total_influence: 6
    )

    @limit_arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: USSR,
      country_names: %i(a b c d e),
      total_influence: 4,
      limit_per_country: 2
    )

    @total_arb = Arbitrators::RemoveInfluence.new(
      player: USSR,
      influence: USSR,
      country_names: %i(a b c d e),
      total_influence: 4,
      total_countries: 2
    )
  end

  def test_accepts_move
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :east_germany,
        amount: 6
      )
    )

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
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :east_germany,
        amount: 4
      )
    )

    @arbitrator.accept(move)

    assert @arbitrator.incomplete?,
      "Should be incomplete because the move does not entirely satisfy"

    assert_equal 2, @arbitrator.remaining_influence,
      "Some influence should be placed"
  end

  def test_invalid_country
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :nonexistant,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The country should be invalid"

    move.instruction.country_name = :east_germany
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_influence
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: US,
        country_name: :east_germany,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The influence should be invalid"

    move.instruction.influence = USSR
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_amount
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :east_germany,
        amount: 7
      )
    )

    refute @arbitrator.accepts?(move), "The amount should be too much"

    move.instruction.amount = 1
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_player
    move = EmptyMove.new(
      player: US,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :east_germany,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The player should be invalid"

    move.player = USSR
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_class
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country_name: :east_germany,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "Instruction class should be invalid"

    move.instruction = Instructions::RemoveInfluence.new(
      influence: USSR,
      country_name: :east_germany,
      amount: 6
    )

    assert @arbitrator.accepts?(move)
  end

  def test_limit_per_country
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :a,
        amount: 3
      )
    )

    refute @limit_arb.accepts?(move), "Places too much influence"

    move.instruction.amount = 2
    assert @limit_arb.accepts?(move)

    @limit_arb.accept(move)

    refute @limit_arb.accepts?(move), "No more influence allowed in 'a'"
  end

  def test_total_countries
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::RemoveInfluence.new(
        influence: USSR,
        country_name: :a,
        amount: 1
      )
    )

    assert @total_arb.accepts?(move)
    @total_arb.accept move

    move.instruction.country_name = :b

    assert @total_arb.accepts?(move)
    @total_arb.accept move

    move.instruction.country_name = :c

    refute @total_arb.accepts?(move), "Too many countries influenced"
  end
end
