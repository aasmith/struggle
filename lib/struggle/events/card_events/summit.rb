module Events
  module CardEvents

    class Summit < Instruction

      needs :countries, :die

      def action
        instructions = []

        us_roll   = die.roll
        ussr_roll = die.roll

        log "%4s rolls %s." % [US, us_roll]
        log "%4s rolls %s." % [USSR, ussr_roll]

        us_roll   += num_regions_dominated_or_controlled(US)
        ussr_roll += num_regions_dominated_or_controlled(USSR)

        log "%4s adjusted roll is %s" % [US, us_roll]
        log "%4s adjusted roll is %s" % [USSR, ussr_roll]

        if ussr_roll > us_roll
          log "%4s wins the roll." % USSR
          winner = USSR

        elsif us_roll > ussr_roll
          log "%4s wins the roll." % US
          winner = US

        else
          log "Rolls draw. No re-rolls."

        end

        if winner
          instructions << Instructions::AwardVictoryPoints.new(
            player: winner,
            amount: 2
          )

          instructions << Arbitrators::AdjustDefcon.new(
            player: winner
          )
        end

        instructions << Instructions::Discard.new(card_ref: "Summit")

        instructions
      end

      def num_regions_dominated_or_controlled(player)
        score = 0

        regions.each do |region_name, region|
          if region.domination?(player)
            score += 1
            log "%4s dominates %s (+1)" % [player, region_name]

          elsif region.control?(player)
            score += 1
            log "%4s controls %s (+1)" % [player, region_name]

          end
        end

        log "%4s adds %s to roll." % [player, score]

        score
      end

      # TODO possibly push this up somewhere common for injection
      def regions
        REGIONS.map do |region_name|
          region = Region.new(countries.select { |c| c.in?(region_name) })

          [region_name, region]
        end
      end

    end

  end
end
