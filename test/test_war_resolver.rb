require "helper"

class WarResolverTest < Struggle::Test

  def test_counts_neighbors
    die = OneSidedDie.new(4)

    a = FakeCountry.new("a")
    a.add_neighbor "b"

    b = FakeCountry.new("b", US)

    countries = FakeCountries.new([a,b])

    resolver = TestableWarResolver.new(die, countries)

    victory = resolver.resolve_war(
      player: USSR,
      country_name: "a",
      victory_range: 4..6
    )

    refute victory, "Should be loss for USSR because of US neighbor control"

    victory = resolver.resolve_war(
      player: US,
      country_name: "a",
      victory_range: 4..6
    )

    assert victory, "Should be victory for US because no modifiers"
  end

  def test_counts_self
    die = OneSidedDie.new(4)

    a = FakeCountry.new("a", US)

    countries = FakeCountries.new([a])

    resolver = TestableWarResolver.new(die, countries)

    victory = resolver.resolve_war(
      player: USSR,
      country_name: "a",
      victory_range: 4..6,
      include_target: true
    )

    refute victory, "Should be loss for USSR because of US target control"

    victory = resolver.resolve_war(
      player: US,
      country_name: "a",
      victory_range: 4..6,
      include_target: true
    )

    assert victory, "Should be victory for US because no modifiers"
  end

  TestableWarResolver = Struct.new(:die, :countries) do
    include WarResolver
  end

  class FakeCountry
    attr_reader :name, :neighbors

    def initialize(name, controlled_by = nil)
      @name = name
      @controlled_by = controlled_by
      @neighbors = []
    end

    def controlled_by?(player)
      @controlled_by == player
    end

    def add_neighbor(n)
      @neighbors << n
    end
  end

  class FakeCountries
    def initialize(countries)
      @countries = countries
    end

    def find(n)
      @countries.detect { |c| c.name == n } or raise "not found: #{n}"
    end
  end
end
