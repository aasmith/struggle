class Engine

  def accept(move)
    modify_score(move)

    if allowed?(move)
      add_expectations generate_expectations_for(move)
    end

    advance
  end

  def generate_expectations_for(move)
  end

  def push(move)
    modify_score(move)

    expectation = stack.peek

    if expectation.accepts?(move) && !veto?(move)
      notify(:on, move)
      expectation.stash(move)
    end
  end

  def advance
    while exp = unsatisfied_expectation_with_unexecuted_moves do
      exp.moves.each do |move| # def exp.execute
        exp.update move
        move.execute
      end
    end
  end
end

e = Engine.new

while e.running?
  p e.state

  e.accept(move)
end

