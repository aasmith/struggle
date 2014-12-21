# A pointer class for referencing the current phasing player.
class PhasingPlayer

  fancy_accessor :player

  def initialize
    self.player = USSR
  end

  def __value__
    player
  end

end
