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

  def test_score_equal
    countries = []
    r = Region.new(countries)

    refute r.score(presence: 1, domination: 3, control: 5)
  end

  def test_score_win_on_battlegrounds
    countries = []
    r = Region.new(countries)

    countries << FakeCountry.battleground(USSR)

    award = r.score(presence: 1, domination: 3, control: 5)

    assert_equal 6,    award.amount, "USSR should have control and one BG"
    assert_equal USSR, award.player

    countries << FakeCountry.battleground(US)

    award = r.score(presence: 1, domination: 3, control: 5)

    refute award, "Both sides equal"
  end

  def test_score_win_on_enemy_superpower_adjacency
    countries = []
    r = Region.new(countries)

    countries << FakeCountry.adjacent_superpower(USSR, adjacent: US)

    award = r.score(presence: 1, domination: 3, control: 5)

    assert_equal 2,    award.amount, "USSR should have presence and adjacency"
    assert_equal USSR, award.player

    countries << FakeCountry.battleground(US)

    award = r.score(presence: 1, domination: 3, control: 5)

    refute award, "Both sides equal"
  end

  def test_score_presence
    countries = []
    r = Region.new(countries)

    countries << FakeCountry.new(USSR)

    award = r.score(presence: 1, domination: 3, control: 5)

    assert_equal 1,    award.amount, "USSR should have presence"
    assert_equal USSR, award.player

    countries << FakeCountry.new(US)

    award = r.score(presence: 1, domination: 3, control: 5)

    refute award, "Both sides equal"
  end

  def test_score_domination
    countries = []
    r = Region.new(countries)

    countries << FakeCountry.new(US)
    countries << FakeCountry.battleground(US)
    countries << FakeCountry.battleground(US)
    countries << FakeCountry.battleground(USSR)

    award = r.score(presence: 1, domination: 3, control: 5)

    #   US   domination (3) + BG (2) : 5
    # - USSR presence   (1) + BG (1) : 2
    #                                = 3
    assert_equal 3,  award.amount, "US should have domination"
    assert_equal US, award.player
  end

  def test_score_control
    countries = []
    r = Region.new(countries)

    countries << FakeCountry.new(US)
    countries << FakeCountry.battleground(US)
    countries << FakeCountry.battleground(US)

    award = r.score(presence: 1, domination: 3, control: 5)

    assert_equal 7,  award.amount, "US should have control + 2 BG"
    assert_equal US, award.player
  end

  class FakeCountry
    def self.battleground(controlled_by)
      new(controlled_by, true)
    end

    def self.adjacent_superpower(controlled_by, adjacent:)
      new(controlled_by, false, adjacent)
    end

    def initialize(controlled_by, battleground = false, adjacent = nil)
      @controlled_by = controlled_by
      @battleground  = battleground
      @adjacent      = adjacent
    end

    def battleground?
      @battleground
    end

    def controlled_by?(superpower)
      @controlled_by == superpower
    end

    def adjacent_superpower?(superpower)
      @adjacent == superpower
    end
  end
end
