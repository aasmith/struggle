module Arbitrators
  class Coup < MoveArbitrator

    fancy_accessor :player, :ops_counter, :country_names

    needs :countries, :defcon

    def initialize(player:, ops_counter:, country_names: nil)
      super

      self.player = player
      self.ops_counter = ops_counter
      self.country_names = country_names
    end

    def before_execute(move)

      # This is the only place we know which country the player is
      # going to coup in. Get the country from the player's instruction,
      # and use it to calculate the ops value. Place that ops value
      # into the instruction.

      country   = countries.find(move.instruction.country_name)
      ops_value = ops_counter.value_for_country(country)

      move.instruction.ops_value = ops_value

      log "%4s to coup in %s" % [player, country]
    end

    def after_execute(move)
      complete
    end

    def accepts?(move)
      coup?(move) && correct_player?(move) && valid_country?(move)
    end

    def coup?(move)
      Instructions::Coup === move.instruction
    end

    def valid_country?(move)
      country_name = move.instruction.country_name
      country = countries.find(country_name)

      # is the country on the list of allowed countries?
      # is the opponent in the country?
      # is the country free of DEFCON restrictions?

      country_whitelisted?(country_name) &&
      country.presence?(player.opponent) &&
      !defcon_affects?(country)
    end

    def defcon_affects?(country)
      defcon.affects?(country)
    end

    def country_whitelisted?(country_name)
      return true if country_names.nil?

      country_names.include?(country_name)
    end

  end

  # A coup without DEFCON restrictions enforced, per 6.3.5.
  class FreeCoup < Coup

    def defcon_affects?(country)
      false
    end
  end
end
