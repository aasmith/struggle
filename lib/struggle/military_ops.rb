class MilitaryOps

  def initialize
    reset
  end

  def increment(player, amount)
    @ops[player] = [@ops[player] + amount, 5].min
  end

  def value(player)
    @ops[player]
  end

  def reset
    @ops = { US => 0, USSR => 0 }
  end

  def calculate_vp(defcon)
    return if us == ussr

    leader = us > ussr ? US : USSR
    vp     = defcon.value > value(leader) ?
             defcon.value - value(leader) :
             defcon.value

    VictoryPointResult.new(leader, vp)
  end

  def us
    value(US)
  end

  def ussr
    value(USSR)
  end

  VictoryPointResult = Struct.new(:player, :vp)
end
