module Arbitrators
  class Realignment < MoveArbitrator

    fancy_accessor :player, :ops_counter

    needs :countries, :defcon

    def initialize(player:, ops_counter:)
      super

      self.player = player
      self.ops_counter = ops_counter
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
