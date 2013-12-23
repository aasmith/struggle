require 'delegate'

class PhasingPlayer < SimpleDelegator

  alias player= __setobj__

  def initialize
    self.player = USSR
  end

end
