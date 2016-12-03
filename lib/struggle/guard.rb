class Guard

  extend Injectable

  attr_accessor :move

  def initialize(move)
    self.move = move
  end

  def player
    move.instruction.player
  end

  def card_ref
    move.instruction.card_ref
  end

  def allows?
    raise NotImplementedError
  end

end
