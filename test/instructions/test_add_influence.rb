require "helper"

class InstructionTests::AddInfluenceTest < Struggle::Test

  def test_add_influence
    country = FakeCountry.new
    countries = FakeCountries.new(country)

    instruction = Instructions::AddInfluence.new(
      influence:    :player,
      amount:       :amount,
      country_name: "foo"
    )

    instruction.countries = countries

    instruction.execute

    assert_equal :player, country.player
    assert_equal :amount, country.amount
  end

  class FakeCountries < Struct.new(:country)
    def find(x)
      country
    end
  end

  class FakeCountry < Struct.new(:player, :amount)
    def add_influence(player, amount)
      self.player = player
      self.amount = amount
    end
  end

end
