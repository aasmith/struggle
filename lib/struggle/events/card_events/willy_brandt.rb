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

        instructions
      end

    end

  end
end
