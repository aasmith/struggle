# ActionRound simulates the "Action Round Track" on the board, specifically
# the location of the Current Player marker. It can be incremented, or reset
# back to the start.

class ActionRound
  def initialize
    @round = nil
  end

  def advance
    @round += 1
  end

  def reset
    @round = 1
  end

  alias start reset

  def number
    @round
  end

end
