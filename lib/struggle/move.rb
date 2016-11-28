class Move
  attr_accessor :player, :instruction

  def initialize(player: nil, instruction: nil)
    self.player = player
    self.instruction = instruction

    @executed = false
  end

  def execute
    results = instruction.execute
    @executed = true
    results
  end

  def executed?
    @executed
  end

  def to_s
    "Move: %s, %s" % [player, instruction.inspect]
  end
end
