module Arbitrators
  class FreeMove < MoveArbitrator

    fancy_accessor :player, :ops

    needs :observers

    def initialize(player:, ops:)
      super

      self.player = player
      self.ops = ops
    end

    def before_execute(move)
      # Same pre-execution insertion technique as in Arbitrators::Coup

      mods = observers.ops_modifiers_for_player(player)

      if move.instruction.respond_to?(:ops_counter=)
        move.instruction.ops_counter = OpsCounter.new(ops, mods)
      end
    end

    def after_execute(move)
      complete
    end

    def accepts?(move)
      acceptable_move?(move) && correct_player?(move)
    end

    def acceptable_move?(move)
      free_move?(move) || noop?(move)
    end

    def free_move?(move)
      Instructions::FreeMove === move.instruction
    end

    def noop?(move)
      Instructions::Noop === move.instruction
    end

  end
end

