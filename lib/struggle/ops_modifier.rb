class OpsModifier
  include Observer

  fancy_accessor :player, :amount, :countries

  def initialize(player:, amount:, terminate: [], countries: [])
    activate

    self.player = player
    self.amount = amount
    self.countries = countries
    self.observation_terminators = [*terminate]
  end

  def conditional?
    !unconditional?
  end

  def unconditional?
    @countries.empty?
  end

  # Given the list +subset_countries+, is the modification of operations
  # points represented by this instance valid?
  #
  # Always returns true if this modifier is unconditional.
  #
  # If the modifier is conditional, then true is only returned if:
  #
  # The provided list of countries is a subset of the list of countries
  # in the modifier.
  #

  def qualifies?(subset_countries)
    unconditional? || subset_countries.all? { |c| countries.include?(c) }
  end

end

