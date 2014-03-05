module Arbitrators

  class AddInfluence < MoveArbitrator
    fancy_accessor :player, :influence, :country_names, :total_influence,
      :limit_per_country, :total_countries

    attr_reader :remaining_influence

    def initialize(player:, influence:, country_names:, total_influence:,
                   limit_per_country: nil, total_countries: nil)
      super

      self.player = player
      self.influence = influence
      self.country_names = country_names
      self.total_influence = total_influence

      # Optional
      self.limit_per_country = limit_per_country
      self.total_countries = total_countries

      @remaining_influence = total_influence

      @country_count = Hash.new(0)
    end

    def after_execute(move)
      country_name = move.instruction.country_name
      amount       = move.instruction.amount

      @remaining_influence -= amount
      @country_count[country_name] += amount

      complete if @remaining_influence.zero?
    end

    # TODO use minitest assertions?
    def accepts?(move)
      country_name = move.instruction.country_name
      amount       = move.instruction.amount

      correct_player?(move) &&
        move.instruction.influence == influence &&
        country_names.include?(country_name) &&
        amount <= remaining_influence &&
        !exceeds_limit_for_country?(country_name, amount) &&
        !exceeds_total_countries?(country_name)
    end

    def exceeds_limit_for_country?(country_name, amount)
      return false if limit_per_country.nil?

      @country_count[country_name] + amount > limit_per_country
    end

    def exceeds_total_countries?(country_name)
      return false if total_countries.nil?

      (countries << country_name).uniq.size > total_countries
    end

    def countries
      @country_count.keys
    end

    def add_country(country_name, amount)
      @country_count[country_names] += amount
    end
  end

end
