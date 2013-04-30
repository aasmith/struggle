require "minitest/autorun"

require "s"

class TestCountry < MiniTest::Unit::TestCase

  def setup
    @countries = Country.initialize_all
  end

  def test_find_unambiguous
    assert Country.find(:west_germany, @countries)
  end

  def test_find_ambiguous
    assert_raises(Country::AmbiguousName) { Country.find(:west, @countries) }
  end

  def test_in?
    cuba = Country.find(:cuba, @countries)

    assert cuba.in?(CentralAmerica)
    refute cuba.in?(Europe)
  end

  def test_in_multiple_regions
    wg = Country.find(:west_germany, @countries)

    assert wg.in?(Europe)
    assert wg.in?(WesternEurope)
  end

  def test_neighbour
    wg = Country.find(:west_germany, @countries)
    fr = Country.find(:france, @countries)
    ca = Country.find(:canada, @countries)

    assert wg.neighbor?(fr)
    refute wg.neighbor?(ca)
  end

  def test_presence
    fr = Country.find(:france, @countries)

    refute fr.presence?(US)
    refute fr.presence?(USSR)

    fr.add_influence!(USSR)

    refute fr.presence?(US)
    assert fr.presence?(USSR)
  end

  def test_controlled_by?
    uk = Country.find(:united_kingdom, @countries)

    refute uk.controlled_by?(USSR)

    (1...uk.stability).each do |n|
      uk.add_influence!(USSR)
      refute uk.controlled_by?(USSR), "Should not have control with #{n} points"
    end

    uk.add_influence!(USSR)
    assert uk.controlled_by?(USSR)

    uk.add_influence!(US)
    refute uk.controlled_by?(USSR)
  end

  def test_price_of_influence
    fr = Country.find(:france, @countries)

    fr.add_influence!(USSR, fr.stability)

    assert_equal fr.price_of_influence(USSR), 1
    assert_equal fr.price_of_influence(US), 2

    fr.add_influence!(US)

    assert_equal fr.price_of_influence(USSR), 1
    assert_equal fr.price_of_influence(US), 1
  end

  def test_self_accessible
    uk = Country.find(:united_kingdom, @countries)
    fr = Country.find(:france, @countries)

    uk.add_influence!(USSR)
    fr.add_influence!(USSR, fr.stability)

    assert uk.presence?(USSR)
    assert fr.controlled_by?(USSR)

    expected = [
      "Algeria",
      "Spain/Portugal",
      "Italy",
      "West Germany",
      "Benelux",
      "Norway",
      "Canada",
      "France",
      "United Kingdom"
    ]

    assert_equal Country.accessible(USSR, @countries).sort, expected.sort
    assert_empty Country.accessible(US, @countries)
  end
end

