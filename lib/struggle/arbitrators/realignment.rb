module Arbitrators
  class Realignment < MoveArbitrator

    fancy_accessor :player, :ops_counter, :country_names

    needs :countries, :defcon

    def initialize(player:, ops_counter:, country_names: nil)
      super

      self.player = player
      self.ops_counter = ops_counter
      self.country_names = country_names
    end

    def before_execute(move)
      country = countries.find(move.instruction.country_name)

      ops_counter.accept([country])

      log "%4s to realign in %s" % [player, country]
    end

    def after_execute(move)
      complete if ops_counter.done?
    end

    def accepts?(move)
      # No need to see if the move is affordable -- each realignment
      # costs one point, and the arbitrator will be marked as complete
      # as soon as all points are spent.

      realignment?(move) && correct_player?(move) && valid_country?(move)
    end

    def realignment?(move)
      Instructions::Realignment === move.instruction
    end

    def valid_country?(move)
      country_name = move.instruction.country_name
      country = countries.find(country_name)

      # is the country on the list of allowed countries?
      # is the opponent in the country?
      # is the country free of DEFCON restrictions?

      country_whitelisted?(country_name) &&
      country.presence?(player.opponent) &&
      !defcon.affects?(country)
    end

    def country_whitelisted?(country_name)
      return true if country_names.nil?

      country_names.include?(country_name)
    end
  end
end
