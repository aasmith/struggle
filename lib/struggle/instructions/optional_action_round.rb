module Instructions
  class OptionalActionRound < Instruction

    fancy_accessor :number

    needs :observers

    def initialize(number:)
      super

      self.number = number
    end

    def action
      players = []

      [USSR, US].each do |player|
        # TODO
        # any OptionalActionRoundModifiers active for player?
        players << player if false
      end

      if players.any?
        log "%s to get an extra Action Round." % players.join(" & ")

        ActionRound.new(players: players, number: number, optional: true)
      else
        log "Neither player qualifies for an extra Action Round."
      end
    end
  end
end
