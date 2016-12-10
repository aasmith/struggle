class TurnMarker

  def initialize
    @turn = nil
  end

  def start
    @turn = 1
  end

  def advance
    @turn += 1
  end

  def number
    @turn
  end

  def early_phase?
    (1..3).include? @turn
  end

  def mid_phase?
    (4..7).include? @turn
  end

  def late_phase?
    (8..10).include? @turn
  end
end
