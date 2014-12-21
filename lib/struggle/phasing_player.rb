class PhasingPlayer

  fancy_accessor :player

  def initialize
    self.player = USSR
  end

  def opponent
    player.opponent
  end

end
