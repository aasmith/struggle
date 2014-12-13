module Events
  module CardEvents

    class JohnPaulIiElectedPope < Instruction

      def action
        instructions = []

        instructions << Instructions::RemoveInfluence.new(
             influence: USSR,
          country_name: "Poland",
                amount: 2
        )

        instructions << Instructions::AddInfluence.new(
             influence: US,
          country_name: "Poland",
                amount: 1
        )

        instructions << Instructions::PlaceInEffect.new(
          card_ref: "JohnPaulIiElectedPope"
        )

        instructions << Instructions::Remove.new(
          card_ref: "JohnPaulIiElectedPope"
        )

        instructions
      end

    end

  end
end
