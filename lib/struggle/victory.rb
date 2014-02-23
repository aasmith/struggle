class Victory < SimpleDelegator

  attr_accessor :reason

  alias winner= __setobj__

  def initialize
    self.winner = nil
    self.reason = nil
  end

end
