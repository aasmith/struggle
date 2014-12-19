module Instructions
  class FreeMove < Instruction

    fancy_accessor :player, :operation, :ops_counter

    VALID_OPERATIONS = %i(influence coup realignment)

    def initialize(player:, operation:)
      super

      self.player = player
      self.operation = operation

      unless VALID_OPERATIONS.include?(operation)
        raise "bad operation #{operation.inspect}"
      end
    end

    def action
      log "%4s uses free move for %s" % [player, operation]

      instructions = []
      instructions.push(*send(operation))
      instructions
    end

    def influence
      Arbitrators::AddRestrictedInfluence.new(
             player: player,
          influence: player,
        ops_counter: ops_counter
      )
    end

    def coup
      Arbitrators::Coup.new(
             player: player,
        ops_counter: ops_counter
      )
    end

    def realignment
      Arbitrators::Realignment.new(
             player: player,
        ops_counter: ops_counter
      )
    end

  end
end

