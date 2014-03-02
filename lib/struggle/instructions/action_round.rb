module Instructions
  class ActionRound < Instruction

    fancy_accessor :players, :number

    def initialize(players: [USSR, US], number:)
      super

      self.players = players
      self.number = number
    end

    def action
      instructions = []

      players.each do |player|
        instructions << PlayerActionRound.new(player: player)
      end

      instructions << ActionRoundEnd.new(number: number)
      instructions
    end

  end
end
