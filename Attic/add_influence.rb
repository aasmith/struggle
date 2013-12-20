class AddInfluence

  PARAMETERS = [:player, :influence,
    :limit_per_country, :total_countries, :total_influence,
    :countries]

  attr_accessor *PARAMETERS

  def initialize(hash)
    raise_on_unknown_keys(hash, PARAMETERS)

    hash.each { |k,v| send(:"#{k}=", v) }

    init_counters
  end

  def raise_on_unknown_keys(hash, allowed_keys)
    unknown_keys = hash.keys - allowed_keys

    unless unknown_keys.empty?
      raise ArgumentError, "Unknown options: %s" % unknown_keys
    end
  end

  def parameters_and_raw_values
    PARAMETERS.map { |p| [p, send(:p)] }
  end

  # Reduce all parameters to an unambiguous value.
  def parameters_and_values
    parameters_and_raw_values.map do |name, raw_value|
      [name, raw_value.respond_to?(:call) ? raw_value.call : raw_value]
    end
  end

  ## def resolve
  ##   if reducible?
  ##     reduce_to_moves
  ##   end
  ## end

  ## def reducible?
  ##   if total_influence
  ##     countries.size * limit_per_country <= total_influence
  ##   elsif total_countries
  ##     countries.size <= total_countries
  ##   else
  ##     true
  ##   end
  ## end

  def allows?(move)
    # check the basics of the move
    Moves::AddInfluence === move &&
      countries.include?(move.country) &&
      player == move.player &&
      influence == move.influence &&

      # specifics
      does_not_exceed_influence_for_country?(move.country, move.amount) &&
      does_not_exceed_total_influence?(move.amount) &&
      does_not_exceed_total_countries?(move.country)
  end

  def does_not_exceed_influence_for_country?(country, requested_amount)
    return true if limit_per_country.nil?

    amount_allowed = @country_scores[country]
    amount_allowed - requested_amount >= 0
  end

  def does_not_exceed_total_influence?(requested_amount)
    return true if total_influence.nil?

    @remaining_total_influence - requested_amount >= 0
  end

  def does_not_exceed_total_countries?(country)
    return true if total_countries.nil?

    (@countries_used | [country]).size > total_countries
  end

  def init_counters
    @country_scores = {}

    countries.each do |c|
      @country_scores[c] = limit_per_country
    end

    @countries_used = []
    @remaining_total_influence = total_influence
  end

  def update(move)
    update_counters(move)
  end

  def update_counters(move)
    deduct_country_score(move.country, move.amount)
    deduct_total_influence(move.amount)
    mark_country_used(move.country)
  end

  def deduct_country_score(country, amount)
    return if limit_per_country.nil?

    @country_scores[country] -= amount
  end

  def deduct_total_influence(amount)
    return if total_influence.nil?

    @remaining_total_influence -= amount
  end

  def mark_country_used(country)
    return if total_countries.nil?

    @countries_used |= [country]
  end

  def satisfied?
  end

  def hint
    Moves::AddInfluence
  end


end

module Moves; end

class Moves::AddInfluence

  attr_accessor :player, :influence, :country, :amount

  def initialize(player: nil, influence: nil, country: nil, amount: nil)
    self.player = player
    self.influence = influence
    self.country = country
    self.amount = amount
  end

  def execute
    #c = game.countries.find(country)
    #c.add_influence(influence, amount)
  end
end

