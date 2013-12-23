class MilitaryOps

  def initialize
    reset
  end

  def increment(player, amount)
    @ops[player] = (x = @ops[player] + amount) > 5 ? 5 : x
  end

  def value(player)
    @ops[player]
  end

  def reset
    @ops = { US => 0, USSR => 0 }
  end

  def required_ops(defcon)
    defcon.value
  end

  def calculate_vp(defcon)
    req = required_ops(defcon)

    result = (req - us) - (req - ussr)

    VictoryPointResult.new(result > 0 ? USSR : US, result.abs)
  end

  def us
    value(US)
  end

  def ussr
    value(USSR)
  end

  VictoryPointResult = Struct.new(:player, :vp)
end
