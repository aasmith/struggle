module Instructions
  class ActionRound < Instruction

    fancy_accessor :players, :number, :optional

    def initialize(players: [USSR, US], number:, optional: false)
      super

      self.players = players
      self.number = number
      self.optional = optional
    end

    def action
      instructions = []

      players.each do |player|
        instructions << PlayerActionRound.new(
          player: player,
          optional: optional
        )
      end

      instructions << ActionRoundEnd.new(number: number)
      instructions
    end

  end
end
