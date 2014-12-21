module Events
  module CardEvents

    class OneSmallStep < Instruction

      needs :space_race, :phasing_player

      def action
        instructions = []

        if behind_on_space_race?
          instructions << Instructions::AdvanceSpaceRace.new(
            player: phasing_player,
            amount: 2
          )
        end

        instructions << Instructions::Discard.new(
          card_ref: "OneSmallStep"
        )

        instructions
      end

      def behind_on_space_race?
        player   = phasing_player
        opponent = phasing_player.opponent

        space_race.position(player) < space_race.position(opponent)
      end

    end

  end
end
