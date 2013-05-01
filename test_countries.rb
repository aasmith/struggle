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

  def test_can_add_influence?
    fr = Country.find(:france, @countries)
    uk = Country.find(:united_kingdom, @countries)

    whitelist = [fr, uk]

    refute fr.can_add_influence?(USSR, whitelist)
    refute uk.can_add_influence?(USSR, whitelist)

    uk.add_influence!(USSR)

    refute fr.can_add_influence?(USSR, [])
    assert fr.can_add_influence?(USSR, whitelist)

    it = Country.find(:italy, @countries)

    fr.add_influence!(USSR)

    refute it.can_add_influence?(USSR, [uk, fr]), <<-MSG
      The target country itself must be in the list of countries in order
      to be regarded as a valid target for placing influence.
    MSG

    jp = Country.find(:japan, @countries)

    assert jp.can_add_influence?(US, []), <<-MSG
      Countries adjacent to a player's superpower must always be allowed
      to receive influence.
    MSG
  end

  def test_player_in_neighboring_country?
    fr = Country.find(:france, @countries)
    uk = Country.find(:united_kingdom, @countries)

    uk.add_influence!(USSR)

    assert fr.player_in_neighboring_country?(USSR, @countries)
    refute uk.player_in_neighboring_country?(USSR, @countries)
  end

  def test_player_adjacent_to_superpower?
    jp = Country.find(:japan, @countries)
    au = Country.find(:australia, @countries)

    assert jp.player_adjacent_to_superpower?(US),
      "Should return true because Japan is adjacent to the US superpower."

    refute au.player_adjacent_to_superpower?(US),
      "Should be false because Australia is not adjacent to the US superpower."
  end

  def test_self_accessible
    uk = Country.find(:united_kingdom, @countries)
    fr = Country.find(:france, @countries)

    uk.add_influence!(USSR)
    fr.add_influence!(USSR, fr.stability)

    assert uk.presence?(USSR)
    assert fr.controlled_by?(USSR)

    expected_neighbors = [
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

    # Those included by virture of superpower adjacency.
    expected_superpower = [
      "Afghanistan",
      "Finland",
      "North Korea",
      "Norway",
      "Poland",
      "Romania"
    ]

    expected = expected_neighbors | expected_superpower

    assert_equal Country.accessible(USSR, @countries).sort, expected.sort

    expected_us = ["Mexico", "Cuba", "Canada", "Japan"]

    assert_equal Country.accessible(US, @countries).sort, expected_us.sort
  end
end

