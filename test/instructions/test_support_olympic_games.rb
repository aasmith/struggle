require "helper"

module InstructionTests
  class SupportOlympicGamesTest < Struggle::Test

    def test_high_roller_gets_additional_two_points_on_roll
      sponsor_olympics = Instructions::SupportOlympicGames.new

      sponsor_olympics.die = OneSidedDie.new(6)
      sponsor_olympics.phasing_player = US

      results = sponsor_olympics.execute

      assert_equal [Instructions::AwardVictoryPoints], results.map(&:class)

      award, * = results

      assert_equal US, award.player
      assert_equal 2,  award.amount
    end

    def test_ties_rerolled
      sponsor_olympics = Instructions::SupportOlympicGames.new

      # Make the first rolls a net draw (USSR will get 4+2, US will get 6).
      # The instruction attempts to roll again, which will cause an error
      # as the ProgrammedDie has no more integers left in its sequence.

      sponsor_olympics.die = ProgrammedDie.new(4,6)
      sponsor_olympics.phasing_player = USSR

      assert_raises ProgrammedDie::SequenceEmpty do
        sponsor_olympics.execute
      end
    end

  end
end
