module Instructions

  # Used for signalling the player's advancement on the space race.
  class SpaceRaceAdvancement < Instruction

    fancy_accessor :player, :position, :first_or_second

    needs :space_race

    def initialize(player:, position:, first_or_second:)
      super

      self.player = player
      self.position = position
      self.first_or_second = first_or_second
    end

    def action
      log "%4s is %s to reach '%s' (position %s) on the Space Race." % [
        player, first_or_second, space_race.position_name(player), position
      ]
    end

  end
end
