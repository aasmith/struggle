# Represents whether a headline phase is currently being played.
class HeadlinePhase

  fancy_accessor :active

  alias active? active

  def initialize
    self.active = false
  end

  def __value__
    active
  end

end
