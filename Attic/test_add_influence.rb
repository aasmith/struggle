require "minitest/autorun"

require "add_influence"

class TestAddInfluence < Minitest::Test

  def setup
  end

  def test_allows?
  end

  def test_limit_per_country
    exp = AddInfluence.new(
      player: :US,
      influence: :US,
      countries: %i(a b c d),
      limit_per_country: 1
    )

    move = Moves::AddInfluence.new(
      player: :US,
      influence: :US,
      country: :a,
      amount: 1
    )

    assert exp.allows?(move)

    bad_move = move.dup
    bad_move.amount = 2
    refute exp.allows?(bad_move)

    bad_move = move.dup
    bad_move.country = :z
    refute exp.allows?(bad_move)

    %i(a b c d).each do |country|
      move.country = country

      exp.update(move)
    end

    # TODO test satisfaction
  end

  def test_limit_per_country_and_total_influence
    exp = AddInfluence.new(
      player: :US,
      influence: :US,
      countries: %i(a b c d),
      limit_per_country: 2,
      total_influence: 4
    )

    move = Moves::AddInfluence.new(
      player: :US,
      influence: :US,
      country: :a,
      amount: 1
    )

    assert exp.allows?(move)

    bad_move = move.dup
    bad_move.amount = 3
    refute exp.allows?(bad_move)
  end

  def test_total_influence
    exp = AddInfluence.new(
      player: :US,
      influence: :US,
      countries: %i(a b c d),
      total_influence: 2
    )

    move = Moves::AddInfluence.new(
      player: :US,
      influence: :US,
      country: :a,
      amount: 1
    )

    assert exp.allows?(move)

    bad_move = move.dup
    bad_move.amount = 3
    refute exp.allows?(bad_move)
  end

  def test_limit_per_country_and_total_countries
  end



end

