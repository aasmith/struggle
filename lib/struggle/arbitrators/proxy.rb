# An arbitrator that fronts multiple arbitrators with a goal of finding
# and proxying for the one arbitrator that accepts a given move.
#
# When a move is provided, if exactly one of the multiple arbitrators
# accepts it, then subsequent moves will be routed to that arbitrator
# until it is complete.
#
# If allows_noop is true (default), a Noop will be accepted, and will
# mark the arbitrator complete if no other arbitrator has yet been selected.

module Arbitrators
  class Proxy < MoveArbitrator

    fancy_accessor :player, :choices, :allows_noop

    alias allows_noop? allows_noop

    attr_reader :selected_arbitrator
    alias arbitrator_selected? selected_arbitrator

    attr_reader :nooped
    alias nooped? nooped

    def initialize(player:, choices:, allows_noop: true)
      super

      self.player = player
      self.choices = choices
      self.allows_noop = allows_noop
    end

    def accepts?(move)
      find_suitable_arbitrator(move) unless arbitrator_selected?

      if arbitrator_selected?
        selected_arbitrator.accepts?(move)

      elsif !arbitrator_selected? && valid_noop?(move)
        @nooped = true
        true

      else
        false

      end
    end

    def before_execute(move)
      selected_arbitrator.before_execute(move) if arbitrator_selected?
    end

    def after_execute(move)
      if arbitrator_selected?
        selected_arbitrator.after_execute(move)

        complete if selected_arbitrator.complete?

      elsif nooped?
        complete

      else
        fail "shouldnt get here"

      end
    end

    def find_suitable_arbitrator(move)
      valid_arbitrators = choices.select { |a| a.accepts?(move) }

      if valid_arbitrators.size == 1
        @selected_arbitrator = valid_arbitrators.first

      elsif valid_arbitrators.empty?
        log "Nothing accepts"

      elsif valid_arbitrators.size > 1
        log "Too many accept"

      end
    end

    def valid_noop?(move)
      allows_noop? && noop?(move) && correct_player?(move)
    end

    def noop?(move)
      Instructions::Noop === move.instruction
    end

  end
end
