require "helper"

# Within the scope of this test class, a 'large move' refers to a player
# move that places more than one influence marker.

class ArbitratorTests::AddRestrictedInfluenceTest < Struggle::Test

  def setup
    # a -- b -- c
    three_countries = [
      ["A Country", 1, false, "Region", ["B Country"]],
      ["B Country", 1, false, "Region", ["A Country", "C Country"]],
      ["C Country", 1, false, "Region", ["B Country"]]
    ]

    # US -- a -- b -- c -- d -- e -- USSR
    five_countries = [
      ["A Country", 1, false, "Region", ["B Country"], "US"],
      ["B Country", 1, false, "Region", ["A Country", "C Country"]],
      ["C Country", 1, false, "Region", ["B Country", "D Country"]],
      ["D Country", 1, false, "Region", ["C Country", "E Country"]],
      ["E Country", 1, false, "Region", ["D Country"], "USSR"],
    ]

    # -- a --
    one_country = [
      ["A Country", 1, false, "Region", []]
    ]

    @three_countries = Countries.new(three_countries)
    @five_countries = Countries.new(five_countries)
    @one_country = Countries.new(one_country)
  end

  # countries:  a -- b -- c
  #
  # USSR has influence in 'a' only.
  #
  # USSR adds 1 inf to b.
  #
  # USSR adds 1 inf to c == fail

  def test_influence_cannot_sneak_outside_of_initial_country_placements
    @three_countries.find(:a).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(5)
    )

    arb.countries = @three_countries

    assert arb.accepts?(add_influence_to("b")),
      "Should allow influence into a neighbor"

    arb.accept add_influence_to("b")

    refute arb.accepts?(add_influence_to("c")),
      "Should not allow influence creep into a new neighbor"

  end

  # countries: US -- a -- b -- c -- d -- e -- USSR
  #
  # USSR has inf in 'c' only.
  #
  # USSR adds 1 inf to e.
  #
  # USSR adds 1 inf to a == fail

  def test_influence_can_always_be_placed_adjacent_to_own_superpower
    @five_countries.find(:c).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(5)
    )

    arb.countries = @five_countries

    assert arb.accepts?(add_influence_to("e")),
      "Should allow influence from own superpower"

    arb.accept add_influence_to("e")

    refute arb.accepts?(add_influence_to("a")),
      "Should not allow influence from enemy superpower"
  end

  # Assuming country 'c' with stability 1
  #
  # c: US 3, USSR 1
  #
  # USSR adds 1 inf, costs 2
  #
  # c: US 3, USSR 2
  #
  # USSR adds 1 inf, costs 2
  #
  # c: US 3, USSR 3
  #
  # USSR adds 1 inf, costs 1
  #
  # c: US 3, USSR 4

  def test_influence_changes_in_price_as_opponent_loses_control
    @one_country.find(:a).add_influence(US, 3)
    @one_country.find(:a).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(5)
    )

    arb.countries = @one_country

    ## Add 1 influence at a cost of 2 points.

    assert arb.accepts?(add_influence_to("a"))

    arb.accept(add_influence_to("a"))

    refute arb.complete?, "Should be remaining influence to place"


    ## Add 1 influence at a cost of 2 points to force loss of enemy control

    assert arb.accepts?(add_influence_to("a"))

    arb.accept(add_influence_to("a"))

    refute arb.complete?, "Should be remaining influence to place"


    ## Add 1 influence at a cost of 1 point to take own control

    assert arb.accepts?(add_influence_to("a"))

    arb.accept(add_influence_to("a"))

    assert arb.complete?, "Should be no more influence to place"
  end

  def test_price_of_influence_changes_in_one_large_move
    @one_country.find(:a).add_influence(US, 3)
    @one_country.find(:a).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(5)
    )

    arb.countries = @one_country

    ## Add all 3 influence at once, for a cost of 5 (2 + 2 + 1)

    assert arb.accepts?(add_influence_to("a", amount: 3)),
      "Should accept a move that places multiple influence"

    arb.accept(add_influence_to("a", amount: 3))

    assert arb.complete?, "Should be no more influence to place"
  end

  def test_insufficient_influence
    @one_country.find(:a).add_influence(US, 10)
    @one_country.find(:a).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(5)
    )

    arb.countries = @one_country

    refute arb.accepts?(add_influence_to("a", amount: 3)),
      "It should be too expensive to place 3 markers, needing 6 points"

  end

  # Similar to test_influence_changes_in_price_as_opponent_loses_control,
  # but the moves place more than one marker each time.

  def test_consecutive_large_moves
    # US controlled, stability 1, country
    #
    # [US: 4, USSR: 1]
    #
    # spend 4 points
    #
    # [US: 4, USSR: 3]
    #
    # spend 3 points
    #
    # [US: 4, USSR: 5]

    @one_country.find(:a).add_influence(US, 4)
    @one_country.find(:a).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(7)
    )

    arb.countries = @one_country


    ## Add 2 influence at a cost of 4 points.

    two_markers = add_influence_to("a", amount: 2)

    assert arb.accepts?(two_markers)

    arb.accept two_markers

    refute arb.complete?, "Should be remaining influence to place"

    ## Add 2 influence at a cost of 3 points to switch control

    two_markers = add_influence_to("a", amount: 2)

    assert arb.accepts?(two_markers)

    arb.accept two_markers

    assert arb.complete?, "Should be no more influence to place"

  end

  def test_invalid_amount
    @one_country.find(:a).add_influence(USSR, 1)

    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(1)
    )

    arb.countries = @one_country

    refute arb.accepts?(add_influence_to("a", amount: 2)),
      "Should reject a move that places too much influence"

    assert arb.accepts?(add_influence_to("a", amount: 1)),
      "Should accept move that doesnt overspend"

  end

  def test_multiple_calls_to_countries_setter_has_no_impact
    arb = Arbitrators::AddRestrictedInfluence.new(
      player: USSR,
      influence: USSR,
      ops_counter: SimpleOpsCounter.new(3)
    )

    arb.countries = iv = "initial_value"
    arb.countries = "new_value"

    assert_equal "initial_value", arb.countries,
      "country assignment should never change after initial assignment"

    refute_same iv, arb.countries,
      "countries should be dup'd upon assignment"
  end

  def add_influence_to(name, amount: 1)
    EmptyMove.new(
      player: USSR,
      instruction: Instructions::AddInfluence.new(
        influence: USSR,
        country_name: name,
        amount: amount
      )
    )
  end

  # A counter that doesnt expect any modifers, applies no bounds,
  # and therefore has a very simple life.

  class SimpleOpsCounter
    def initialize(amount)
      @amount = amount
    end

    def accepts?(things)
      @amount - things.size >= 0
    end

    def accept(things)
      @amount -= things.size
    end

    def done?
      @amount.zero?
    end
  end
end
