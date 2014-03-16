class Defcon

  attr_reader :value

  def initialize(value = 5)
    @value = value
  end

  def improve(amount = nil)
    raise ArgumentError, "Must be positive" if amount < 0

    set([value + amount, 5].min)
  end

  def degrade(amount)
    raise ArgumentError, "Must be positive" if amount < 0

    set(value - amount)
  end

  def set(value)
    if one?
      raise ImmutableDefcon, "DEFCON can no longer be changed."
    end

    unless (1..5).include? value
      raise InvalidDefcon, "Invalid DEFCON value #{value.inspect}"
    end

    @value = value
  end

  def one?
    value == 1
  end

  DEFCON_RESTRICTIONS = {
    5 => [],
    4 => [Europe],
    3 => [Europe, Asia],
    2 => [Europe, Asia, MiddleEast]
  }

  # Returns a list of regions that are defcon-restricted by
  # the current DEFCON level.

  def restricted_regions
    DEFCON_RESTRICTIONS.fetch(value) do |key|
      raise ArgumentError, "DEFCON is at 1, why are you asking?"
    end
  end

  # Returns true if the given country is in the list of DEFCON
  # restricted regions.

  def affects?(country)
    (country.regions & restricted_regions).any?
  end

end

ImmutableDefcon = Class.new(StandardError)
InvalidDefcon = Class.new(StandardError)
