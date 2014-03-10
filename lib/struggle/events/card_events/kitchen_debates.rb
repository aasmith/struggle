module Events
  module CardEvents

    class KitchenDebates < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Instructions::Noop.new(label: "something")

        # Returns a remove or discard instruction based on whether
        # the award condition is true. See Rules 5.2 example 4.

        if us_controls_more_battlegrounds?
          instructions << AwardVictoryPoints.new(
            player: US,
            amount: 2
          )

          instructions << Instructions::Remove.new(
            card_ref: "KitchenDebates"
          )

        else
          instructions << Instructions::Discard.new(
            card_ref: "KitchenDebates"
          )

        end

        instructions
      end

      def us_controls_more_battlegrounds?
        battlegrounds = countries.select { |c| c.battleground? }

        ussr = battlegrounds.count { |c| c.controlled_by?(USSR) }
        us   = battlegrounds.count { |c| c.controlled_by?(US)   }

        us > ussr
      end

    end

  end
end
