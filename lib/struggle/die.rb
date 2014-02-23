class Die

  NUMBERS = [*1..6]

  def initialize(rng)
    @rng = rng
  end

  def roll
    NUMBERS.sample(random: @rng)
  end

end

