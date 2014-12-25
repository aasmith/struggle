module Events
  module CardEvents

    class WillyBrandt < Instruction

      needs :events_in_effect

      def action
        instructions = []

        if events_in_effect.include?("TearDownThisWall")

          instructions << Instructions::Discard.new(
            card_ref: "WillyBrandt"
          )

        else

          instructions << Instructions::PlaceInEffect.new(
            card_ref: "WillyBrandt"
          )

          instructions << Instructions::AwardVictoryPoints.new(
            player: USSR,
            amount: 1
          )

          instructions << Instructions::AddInfluence.new(
               influence: USSR,
                  amount: 1,
            country_name: "West Germany"
          )

          instructions << Instructions::Remove.new(
            card_ref: "WillyBrandt"
          )

        end

        # TODO Regarding canceling NATO effect for West Germany:
        # The nato modifier should check for this event being in effect.
        # NATO modifier will enforce the clause regarding coup/realign/brush.

        instructions
      end

    end

  end
end
