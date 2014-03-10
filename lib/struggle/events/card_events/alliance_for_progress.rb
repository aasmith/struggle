module Events
  module CardEvents

    class AllianceForProgress < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: us_controlled_battlegrounds_in_americas
        )

        instructions << Instructions::Remove.new(
          card_ref: "AllianceForProgress"
        )

        instructions
      end

      def us_controlled_battlegrounds_in_americas
        countries.
          select { |c| c.in?(CentralAmerica) || c.in?(SouthAmerica) }.
          select { |c| c.battleground? }.
          select { |c| c.controlled_by?(US) }.
          size
      end

    end

  end
end
