require "minitest/autorun"

require "engine3"

class TestEngine3 < Minitest::Test

  def test_move_executes
    game = Game.new
    move = Move.new("Simple")

    game.add_tasks move
    game.execute_tasks

    assert move.executed?
  end

  def test_conditional_adds_moves
    game = Game.new

    true_moves = [Move.new("true1"), Move.new("true2")]
    false_moves = [Move.new("false1")]

    if_statement = IfStatement.new(lambda { 3 > 2 }, true_moves, false_moves)

    g.add_tasks if_statement
    game.execute_tasks

    true_moves.each  { |m| assert m.executed?, "All true moves should execute" }
    false_moves.each { |m| refute m.executed?, "No false moves should execute" }
  end
end
