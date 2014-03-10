module Events
  module CardEvents

    class DuckAndCover < Instruction

      needs :defcon

      def action
        instructions = []

        instructions << Instructions::DegradeDefcon.new(
          cause: self
        )

        award = 5 - defcon.value

        # Don't make a zero VP award
        unless award.zero?
          instructions << Instructions::AwardVictoryPoints.new(
            player: US,
            amount: award
          )
        end

        instructions << Instructions::Discard.new(
          card_ref: "DuckAndCover"
        )

        instructions
      end

    end

  end
end
