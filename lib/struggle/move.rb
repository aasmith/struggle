class Move
  attr_accessor :player, :instruction

  def initialize(player: nil, instruction: nil)
    self.player = player
    self.instruction = instruction
  end

  def execute
    instruction.execute
  end

  def executed?
    raise NotImplementedError
  end
end

