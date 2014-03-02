module Instructions
  class PlayerActionRound < Instruction

    fancy_accessor :player

    def initialize(player:)
      super

      self.player = player
    end

    def action
      # TODO
      # might need this to comply with 6.1.1 -- capturing country markers
      # that are in place at the begining of the player's AR
      #
      # sets game.countries_snapshot = game.countries.dup
      #
      # the AddRestrictedInfluence arbitrator can access this var instead.
      #
      # Instruction(:SnapshotCountries)

      instructions = []

      instructions << SetPhasingPlayer.new(player: player)
      instructions << Arbitrators::CardPlay.new(player: player)
      instructions << DisposeCurrentCards.new
      instructions << PlayerActionRoundEnd.new(player: player)

      instructions
    end
  end
end
