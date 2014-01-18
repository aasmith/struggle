require "helper"

class TestCountries < Struggle::Test

  def setup
    @countries = Countries.new(COUNTRY_DATA)
  end

  def test_data_loading
    peru = @countries.find(:peru)

    refute peru.battleground?
    refute peru.adjacent_superpower

    assert_equal "Peru", peru.name
    assert_equal 2, peru.stability
    assert_equal [SouthAmerica], peru.regions
    assert_equal %w(Ecuador Bolivia Chile), peru.neighbors

    poland = @countries.find(:poland)

    assert poland.battleground?

    assert_equal "Poland", poland.name
    assert_equal 3, poland.stability
    assert_equal [EE, EU], poland.regions.sort
    assert_equal USSR, poland.adjacent_superpower
    assert_equal ["Czechoslovakia", "East Germany"], poland.neighbors
  end

  def test_find_unambiguous
    assert @countries.find(:west_germany)
  end

  def test_find_ambiguous
    assert_raises(Countries::AmbiguousNameError) { @countries.find(:west) }
  end

  def test_find_not_found
    assert_raises(Countries::CountryNotFoundError) { @countries.find(:xyz) }
  end

  def test_dup
    d = @countries.dup

    refute_same d.find(:poland), @countries.find(:poland),
      "Each country should be duplicated"
  end
end
