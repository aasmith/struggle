require "helper"

class ArbitratorTests::AddInfluenceTest < Struggle::Test

  def setup
    @arbitrator = Arbitrators::AddInfluence.new(
      player: USSR,
      influence: USSR,
      countries: [:east_germany, :west_germany],
      total_influence: 6
    )
  end

  def test_accepts_move
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country: :east_germany,
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
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country: :east_germany,
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
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country: :nonexistant,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The country should be invalid"

    move.instruction.country = :east_germany
    assert @arbitrator.accepts?(move)
  end

  def test_invalid_influence
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::AddInfluence.new(
        influence: US,
        country: :east_germany,
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
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country: :east_germany,
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
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country: :east_germany,
        amount: 6
      )
    )

    refute @arbitrator.accepts?(move), "The player should be invalid"

    move.player = USSR
    assert @arbitrator.accepts?(move)
  end

end
