module Events
  module CardEvents

    class Solidarity < Instruction

      needs :events_in_effect

      def action
        instructions = []

        if events_in_effect.include?("JohnPaulIiElectedPope")

          instructions << Instructions::AddInfluence.new(
               influence: US,
                  amount: 3,
            country_name: "Poland"
          )

          instructions << Instructions::Remove.new(
            card_ref: "Solidarity"
          )

        else
          instructions << Instructions::Discard.new(
            card_ref: "Solidarity"
          )
        end

        instructions
      end

    end

  end
end
