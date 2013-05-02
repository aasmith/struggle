
require "minitest/autorun"

require "s"

class TestTerminators < MiniTest::Unit::TestCase

  def test_game_cycle
    i = 0
    ex = nil

    turns = Hash.new { |h,k| h[k] = [] }

    loop do
      t = ex ? ex.terminator : Terminators::HeadlineCardRound.new
      ex = t.execute([])

      turns[t.turn] << t

      break if Terminators::GameEnd === t

      fail "Test ran too many iterations." if (i += 1) > 2000
    end

    test = lambda { |n, turn, terminators|
      assert_equal n + 3, terminators.size, <<-MSG
        Turn #{turn} should have #{n + 3} terminators
      MSG

      assert_kind_of Terminators::HeadlineCardRound, t = terminators.shift
      assert_equal turn, t.turn

      assert_kind_of Terminators::HeadlineEventsEnd, t = terminators.shift
      assert_equal turn, t.turn

      n.times do |i|
        assert_kind_of Terminators::ActionRoundEnd, t = terminators.shift
        assert_equal i + 1, t.counter
        assert_equal turn, t.turn
      end

      assert_kind_of Terminators::TurnEnd, t = terminators.shift
      assert_equal turn, t.turn
    }

    test_end = lambda { |terminators|
      assert_equal 1, terminators.size
      assert_kind_of Terminators::GameEnd, terminators.shift
    }

    turns.each do |turn, results|
      case turn
      when 1..3  then test.call(6, turn, results)
      when 4..10 then test.call(7, turn, results)
      when nil    then test_end.call(results)
      else fail "unexpected turn #{turn.inspect}!"
      end
    end
  end

end
