require "helper"

class RegionTest < Struggle::Test

  def test_presence
    countries = []
    r = Region.new(countries)

    refute r.presence?(USSR)
    refute r.presence?(US)

    countries << FakeCountry.new(USSR)

    assert r.presence?(USSR)
    refute r.presence?(US)

    countries << FakeCountry.new(US)

    assert r.presence?(USSR)
    assert r.presence?(US)
  end

  def test_domination
    countries = []
    r = Region.new(countries)

    refute r.domination?(USSR)
    refute r.domination?(US)

    countries << FakeCountry.new(USSR)

    refute r.domination?(USSR)
    refute r.domination?(US)

    countries << FakeCountry.battleground(USSR)

    assert r.domination?(USSR)
    refute r.domination?(US)

    countries << FakeCountry.new(US)

    assert r.domination?(USSR)
    refute r.domination?(US)

    countries << FakeCountry.battleground(US)

    refute r.domination?(USSR)
    refute r.domination?(US)
  end

  def test_control
    empty_battleground = FakeCountry.battleground(nil)
    countries = [empty_battleground]

    r = Region.new(countries)

    refute r.control?(USSR)
    refute r.control?(US)

    countries << FakeCountry.new(USSR)

    refute r.control?(USSR)
    refute r.control?(US)

    countries << FakeCountry.battleground(USSR)

    refute r.control?(USSR)
    refute r.control?(US)

    countries.delete(empty_battleground)

    assert r.control?(USSR)
    refute r.control?(US)

    countries << FakeCountry.battleground(US)

    refute r.control?(USSR)
    refute r.control?(US)
  end

  class FakeCountry
    def self.battleground(controlled_by)
      new(controlled_by, true)
    end

    def initialize(controlled_by, battleground = false)
      @controlled_by = controlled_by
      @battleground  = battleground
    end

    def battleground?
      @battleground
    end

    def controlled_by?(superpower)
      @controlled_by == superpower
    end
  end
end
