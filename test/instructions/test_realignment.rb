require "helper"

# TODO This test needs to test for the correct application of
# die roll modifiers when present. (via Observers.new(...))

class RealignmentTest < Struggle::Test

  I = Instructions

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

  def realignment(player: player, country: country, die: Die.new(Random.new))
    realignment = Instructions::Realignment.new(
      player: player,
      country_name: :notimportant
    )

    realignment.countries = FakeCountries.new(country)
    realignment.observers = Observers.new([])
    realignment.die       = die

    realignment
  end

  def test_ties_do_nothing
    realignment = Instructions::Realignment.new(player: US, country_name: "A")

    @one_country.find("A").add_influence(USSR, 1)
    @one_country.find("A").add_influence(US  , 1)

    realignment.countries = @one_country
    realignment.observers = Observers.new([])
    realignment.die       = OneSidedDie.new(1)

    assert_nil realignment.action, "Should be no instructions for a tie"
  end

  def test_all_influence_removed
    realignment = Instructions::Realignment.new(player: US, country_name: "A")

    @one_country.find("A").add_influence(USSR, 4)
    @one_country.find("A").add_influence(US  , 4)

    realignment.countries = @one_country
    realignment.observers = Observers.new([])
    realignment.die       = ProgrammedDie.new(6,1)

    instruction = realignment.action

    assert_instance_of  Instructions::RemoveInfluence, instruction

    assert_equal USSR, instruction.influence
    assert_equal 4,    instruction.amount

    assert_equal "A Country", instruction.country_name
  end

  def test_some_influence_removed
    realignment = Instructions::Realignment.new(player: US, country_name: "A")

    @one_country.find("A").add_influence(USSR, 4)
    @one_country.find("A").add_influence(US  , 4)

    realignment.countries = @one_country
    realignment.observers = Observers.new([])
    realignment.die       = ProgrammedDie.new(1,3)

    instruction = realignment.action

    assert_instance_of  Instructions::RemoveInfluence, instruction

    assert_equal US, instruction.influence
    assert_equal 2,  instruction.amount

    assert_equal "A Country", instruction.country_name
  end

  def test_bonuses_more_influence_in_target_country
    realignment = Instructions::Realignment.new(player: US, country_name: "A")

    @one_country.find("A").add_influence(USSR, 3)
    @one_country.find("A").add_influence(US  , 1)

    realignment.countries = @one_country
    realignment.observers = Observers.new([])
    realignment.die       = Die.new(Random.new)

    assert_equal 0, realignment.bonuses(US,   @one_country.find("A"))
    assert_equal 1, realignment.bonuses(USSR, @one_country.find("A"))
  end

  def test_bonuses_adjacent_superpower
    realignment = Instructions::Realignment.new(player: US, country_name: "A")

    @five_countries.find("A").add_influence(USSR, 1)
    @five_countries.find("A").add_influence(US  , 1)

    realignment.countries = @five_countries
    realignment.observers = Observers.new([])
    realignment.die       = Die.new(Random.new)

    assert_equal 1, realignment.bonuses(US,   @five_countries.find("A"))
    assert_equal 0, realignment.bonuses(USSR, @five_countries.find("A"))
  end

  def test_bonuses_control_of_neighbors
    realignment = Instructions::Realignment.new(player: US, country_name: "C")

    @five_countries.find("A").add_influence(USSR, 1)
    @five_countries.find("B").add_influence(USSR, 1)
    @five_countries.find("D").add_influence(US,   1)
    @five_countries.find("E").add_influence(US,   1)

    realignment.countries = @five_countries
    realignment.observers = Observers.new([])
    realignment.die       = Die.new(Random.new)

    assert_equal 1, realignment.bonuses(US,   @five_countries.find("C"))
    assert_equal 1, realignment.bonuses(USSR, @five_countries.find("C"))
  end

  def test_bonuses_nothing
    realignment = Instructions::Realignment.new(player: US, country_name: "C")

    realignment.countries = @five_countries
    realignment.observers = Observers.new([])
    realignment.die       = Die.new(Random.new)

    assert_equal 0, realignment.bonuses(US,   @five_countries.find("C"))
    assert_equal 0, realignment.bonuses(USSR, @five_countries.find("C"))
  end

  class ProgrammedDie
    def initialize(*seq)
      @seq = seq.dup
    end

    def roll
      @seq.shift
    end
  end

end
