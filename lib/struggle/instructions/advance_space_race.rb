module Instructions

  # Advance player on the space race by amount. Only collect the VP
  # award on the final square. Gain or cancel the event at each
  # applicable square.

  class AdvanceSpaceRace < Instruction

    fancy_accessor :player, :amount

    needs :space_race

    def initialize(player:, amount:)
      super

      self.player = player
      self.amount = amount
    end

    def action
      return unless amount > 0

      instructions = []

      first_or_second = nil

      amount.times do
        first_or_second = space_race.advance(player)

        instructions << SpaceRaceAdvancement.new(
          player: player,
          position: space_race.position(player),
          first_or_second: first_or_second
        )

        if first_or_second == :first
          # TODO lookup possible event from card components
          instructions << Noop.new(label: "Possible space race event reward")
        end
      end

      reward = VP_REWARDS[space_race.position(player)]

      vp = reward.points(first_or_second)

      if vp > 0
        instructions << AwardVictoryPoints.new(player: player, amount: vp)
      end

      instructions
    end

    VpReward = Struct.new(:first, :second) do
      def points(first_or_second)
        send first_or_second
      end
    end

    VP_REWARDS = {
      1 => VpReward.new(2,1),
      3 => VpReward.new(2,0),
      5 => VpReward.new(3,1),
      7 => VpReward.new(4,2),
      8 => VpReward.new(2,0),
    }

    VP_REWARDS.default = VpReward.new(0,0)

  end

end
