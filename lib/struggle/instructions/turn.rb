module Instructions

  class Turn < Instruction

    fancy_accessor :num_cards, :num_rounds

    def initialize(num_cards:, num_rounds:)
      super

      self.num_cards  = num_cards
      self.num_rounds = num_rounds
    end

    def action
      instructions = []

      instructions << ImproveDefcon.new(amount: 1)
      instructions << DealCards.new(target: num_cards)
      instructions << HeadlinePhase.new

      num_rounds.times do |n|
        instructions << ActionRound.new(number: n + 1)
      end

      instructions << OptionalActionRound.new(number: num_cards + 1)

      # for certain events to trigger off of
      instructions << ActionRoundsEnd.new

      instructions << CheckMilitaryOps.new
      instructions << ResetMilitaryOps.new

      # Although not called out explicitly in Section 4.5, space race
      # attempts are reset each turn per Section 6.4.2.
      instructions << ResetSpaceRaceAttempts.new

      instructions << CheckHeldCards.new
      instructions << FlipChinaCard.new
      instructions << DiscardHeldCard.new
      instructions << AdvanceTurn.new

      instructions
    end

  end

end
