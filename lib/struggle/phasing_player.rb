class PhasingPlayer

  fancy_accessor :player

  def initialize
    self.player = USSR
  end

  alias __value__ player

end
