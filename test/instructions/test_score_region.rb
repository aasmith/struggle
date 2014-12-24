require "helper"

class InstructionTests::ScoreRegionTest < Struggle::Test

  def setup
    @instruction = Instructions::ScoreRegion.new(
      region_name: Europe,
      presence:    1,
      domination:  5,
      control:     9
    )

    @instruction.observers = Observers.new([])
  end

  def test_europe_control_wins
    @instruction.countries = [
      FakeCountry.battleground(USSR),
      FakeCountry.new(USSR),
      FakeCountry.new(US),
    ]

    win, terminate = @instruction.action

    assert_instance_of Instructions::DeclareWinner, win
    assert_equal USSR, win.player

    assert_instance_of Instructions::EndGame, terminate
  end

  def test_vp_award
    @instruction.countries = [
      FakeCountry.battleground(USSR),
      FakeCountry.battleground(USSR),
      FakeCountry.battleground(US),
      FakeCountry.new(USSR),
    ]

    award,_ = @instruction.action

    assert_instance_of Instructions::AwardVictoryPoints, award
    assert_equal USSR, award.player
    assert_equal 5,    award.amount
  end

  def test_no_award
    @instruction.countries = [
      FakeCountry.new(USSR),
      FakeCountry.new(US),
    ]

    assert_empty @instruction.action
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

    def adjacent_superpower?(_)
      false
    end

    def in?(whatever)
      true
    end
  end

end
