module Instructions
  class StartingInfluence < Instruction

    needs :countries

    def action
      instructions = []

      influences = [
        [USSR, 2, "Syria"],
        [USSR, 1, "Iraq"],
        [USSR, 3, "North Korea"],
        [USSR, 3, "East Germany"],
        [USSR, 1, "Finland"],
        [US,   1, "Iran"],
        [US,   1, "Israel"],
        [US,   1, "Japan"],
        [US,   4, "Australia"],
        [US,   1, "Philippines"],
        [US,   1, "South Korea"],
        [US,   1, "Panama"],
        [US,   1, "South Africa"],
        [US,   5, "United Kingdom"]
      ]

      influences.each do |influence, amount, country_name|

        instructions << Instructions::AddInfluence.new(
             influence: influence,
                amount: amount,
          country_name: country_name
        )

      end

      instructions << Arbitrators::AddInfluence.new(
                 player: USSR,
              influence: USSR,
        total_influence: 6,
          country_names: countries.
                         select { |c| c.in?(EasternEurope) }.
                         map    { |c| c.name }
      )

      instructions << Arbitrators::AddInfluence.new(
                 player: US,
              influence: US,
        total_influence: 7,
          country_names: countries.
                         select { |c| c.in?(WesternEurope) }.
                         map    { |c| c.name }
      )

      instructions
    end

  end
end
