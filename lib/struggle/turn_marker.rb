class TurnMarker

  def initialize(turn = 1)
    @turn = turn
  end

  def advance
    @turn += 1
  end

  def number
    @turn
  end
end
