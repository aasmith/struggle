class Defcon
  attr_reader :value, :destroyed_by

  def initialize(value = 5)
    @value = value
    @destroyed_by = nil
  end

  def improve(amount = nil)
    raise ArgumentError, "Must be positive" if amount < 0

    set(nil, [value + amount, 5].min)
  end

  def degrade(player, amount)
    raise ArgumentError, "Must be positive" if amount < 0

    set(player, value - amount)
  end

  def set(player, value)
    if player.nil? && value == 1
      raise ArgumentError, "Player needed when setting DEFCON to WAR!"
    end

    if nuclear_war?
      raise ImmutableDefcon, "DEFCON can no longer be changed."
    end

    unless (1..5).include? value
      raise InvalidDefcon, "Invalid DEFCON value #{value.inspect}"
    end

    @value = value

    declare_nuclear_war(player) if value <= 1
  end

  def declare_nuclear_war(player)
    @destroyed_by = player
  end

  def nuclear_war?
    destroyed_by
  end

end

ImmutableDefcon = Class.new(StandardError)
InvalidDefcon = Class.new(StandardError)
