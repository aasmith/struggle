module Events
  module CardEvents

    class SouthAfricanUnrest < Instruction

      def action
        instructions = []

        instructions << Instructions::AddInfluence.new(
             influence: USSR,
                amount: 1,
          country_name: "South Africa"
        )

        one_more_in_sa = Arbitrators::AddInfluence.new(
                   player: USSR,
                influence: USSR,
            country_names: ["South Africa"],
          total_influence: 1
        )

        two_between_angola_and_botswana = Arbitrators::AddInfluence.new(
                   player: USSR,
                influence: USSR,
            country_names: %w(Angola Botswana),
          total_influence: 2
        )

        instructions << Arbitrators::Proxy.new(
           player: USSR,
          choices: [one_more_in_sa, two_between_angola_and_botswana]
        )

        instructions << Instructions::Discard.new(
          card_ref: "SouthAfricanUnrest"
        )

        instructions
      end

    end

  end
end
