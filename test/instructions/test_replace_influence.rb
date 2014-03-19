require "helper"

class InstructionTests::ReplaceInfluenceTest < Struggle::Test

  def test_replaces_influence_with_opponent
    country = FakeCountry.new(us: 4, ussr: 2)
    countries = FakeCountries.new(country)

    replace = Instructions::ReplaceInfluence.new(
      player: US,
      country_name: "fake"
    )

    replace.countries = countries

    remove, add = replace.execute

    assert_instance_of Instructions::RemoveInfluence, remove
    assert_instance_of Instructions::AddInfluence, add

    assert_equal "fake", remove.country_name
    assert_equal US,     remove.influence
    assert_equal 4,      remove.amount

    assert_equal "fake", add.country_name
    assert_equal USSR,   add.influence
    assert_equal 4,      add.amount
  end

  def test_nothing_happens_when_no_influence
    country = FakeCountry.new(us: 0, ussr: 2)
    countries = FakeCountries.new(country)

    replace = Instructions::ReplaceInfluence.new(
      player: US,
      country_name: "fake"
    )

    replace.countries = countries

    assert_nil replace.execute
  end

  class FakeCountry
    def initialize(us: 0, ussr: 0)
      @inf = { US => us, USSR => ussr }
    end

    def influence(player)
      @inf.fetch(player)
    end
  end
end
