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

      instructions << DealCards.new(target: num_cards)
      instructions << DealCards.new(target: num_cards)

      # for certain events to trigger off of
      instructions << ActionRoundsEnd.new

      instructions << CheckMilitaryOps.new
      instructions << ResetMilitaryOps.new

      instructions << CheckHeldCards.new
      instructions << FlipChinaCard.new
      instructions << DiscardHeldCard.new
      instructions << AdvanceTurn.new

      instructions
    end

  end

end
