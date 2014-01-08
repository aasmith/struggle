class Victory < SimpleDelegator

  alias winner= __setobj__

  def initialize
    self.winner = nil
  end

end
