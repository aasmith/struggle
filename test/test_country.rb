require "helper"

class TestCountry < Struggle::Test

  def setup
    # Country "Foo" has stability 3, is not a battleground, belongs in regions
    # "x" and "y", and neighbors countries "a" and "b".
    @country = Country.new("Foo", 3, false, %w(a b), %w(x y), "USSR")
  end

  def test_in?
    assert @country.in?("a")
    assert @country.in?("b")
    refute @country.in?("c")
  end

  def test_neighbor_as_country
    fake_neighbor = Struct.new(:name).new("x")
    fake_country  = Struct.new(:name).new("z")

    assert @country.neighbor?(fake_neighbor)
    refute @country.neighbor?(fake_country)
  end

  def test_influence
    assert_equal 0, @country.influence(US)
    assert_equal 0, @country.influence(USSR)
  end

  def test_empty?
    assert @country.empty?
    @country.add_influence(US, 1)
    refute @country.empty?
  end

  def test_add_influence
    @country.add_influence(US, 3)
    @country.add_influence(USSR, 2)

    assert_equal 3, @country.influence(US)
    assert_equal 2, @country.influence(USSR)

    assert_raises(ArgumentError) do
      @country.add_influence(Object.new, 2)
    end

    assert_raises(Country::NegativeInfluenceError) do
      @country.add_influence(US, -2)
    end
  end

  def test_removing_too_much_influence
    assert_raises(RangeError) do
      @country.remove_influence(US, 3)
    end

    assert_raises(RangeError) do
      @country.remove_influence(USSR, 2)
    end
  end

  def test_remove_influence
    @country.add_influence(US, 3)
    @country.add_influence(USSR, 2)

    @country.remove_influence(US, 2)
    @country.remove_influence(USSR, 1)

    assert_equal 1, @country.influence(US)
    assert_equal 1, @country.influence(USSR)

    assert_raises(ArgumentError) do
      @country.remove_influence(Object.new, 2)
    end

    assert_raises(Country::NegativeInfluenceError) do
      @country.remove_influence(US, -2)
    end
  end

  def test_presence
    refute @country.presence?(US)
    refute @country.presence?(USSR)

    @country.add_influence(USSR, 1)

    refute @country.presence?(US)
    assert @country.presence?(USSR)
  end

  def test_control
    refute @country.controlled_by?(USSR)
    refute @country.controlled?, "No one should have control"

    (1...@country.stability).each do |n|
      @country.add_influence(USSR, 1)

      refute @country.controlled_by?(USSR),
        "USSR should not have control with #{n} points"

      refute @country.controlled?, "No one should have control"
    end

    @country.add_influence(USSR, 1)
    assert @country.controlled_by?(USSR), "USSR should have control"
    assert @country.controlled?

    @country.add_influence(US, 1)
    refute @country.controlled_by?(USSR),
      "USSR should lose control after US influence placement"

    refute @country.controlled?, "No one should have control"
  end

  def test_price_of_influence
    @country.add_influence(USSR, @country.stability)

    assert_equal @country.price_of_influence(USSR), 1,
      "Influence should cost 1 because friendly has control"

    assert_equal @country.price_of_influence(US), 2,
      "Influence should cost 2 because enemy has control"

    @country.add_influence(US, 1)

    assert_equal @country.price_of_influence(USSR), 1,
      "Influence should cost 1 because the country is uncontrolled"
    assert_equal @country.price_of_influence(US), 1,
      "Influence should cost 1 because the country is uncontrolled"
  end

  def test_player_adjacent_to_superpower?
    assert @country.player_adjacent_to_superpower?(USSR)
    refute @country.player_adjacent_to_superpower?(US)

    isolated = Country.new("Bar", 1, false, [], [])

    refute isolated.player_adjacent_to_superpower?(USSR)
    refute isolated.player_adjacent_to_superpower?(US)
  end

  def test_dup
    c = Country.new("A", 1, false, [], [])

    d = c.dup

    refute_same c.instance_variable_get("@influence"),
      d.instance_variable_get("@influence"),
      "Influence hash should be duplicated"
  end
end

