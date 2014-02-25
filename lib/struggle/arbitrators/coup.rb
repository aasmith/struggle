module Arbitrators
  class Coup < MoveArbitrator

    fancy_accessor :player, :ops_counter

    needs :countries, :defcon

    def initialize(player:, ops_counter:)
      super

      self.player = player
      self.ops_counter = ops_counter
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
      correct_player?(move) && valid_country?(move)
    end

    def valid_country?(move)
      country = countries.find(move.instruction.country_name)

      # is the opponent in the country?
      # is the country free of DEFCON restrictions?
      country.presence?(player.opponent) && !defcon.affects?(country)
    end

  end
end
