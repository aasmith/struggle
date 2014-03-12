module Events
  module CardEvents

    class MarineBarracksBombing < Instruction

      needs :countries

      def action
        instructions = []

        lebanon = countries.find("Lebanon")

        instructions << Instructions::RemoveInfluence.new(
             influence: US,
          country_name: "Lebanon",
                amount: lebanon.influence(US)
        )

        instructions << Arbitrators::RemoveInfluence.new(
                   player: USSR,
                influence: US,
            country_names: middle_east,
          total_influence: 2
        )

        instructions << Instructions::Remove.new(
          card_ref: "MarineBarracksBombing"
        )

        instructions
      end

      def middle_east
        countries.
          select { |c| c.in?(MiddleEast) }.
          map    { |c| c.name }
      end

    end

  end
end
