module Instructions
  class SupportOlympicGames < Instruction

    needs :phasing_player, :die

    def action
      instructions = []

      sponsor_roll  = nil
      opponent_roll = nil

      sponsor = phasing_player

      loop do
        sponsor_roll  = die.roll
        opponent_roll = die.roll

        log "%4s rolls %s"              % [sponsor, sponsor_roll]
        log "%4s sponsor roll + 2 = %s" % [sponsor, sponsor_roll += 2]
        log "%4s rolls %s"              % [sponsor.opponent, opponent_roll]

        # Re-roll ties
        if sponsor_roll == opponent_roll
          log "Outcome is a tie, re-rolling"
        else
          break
        end
      end

      victor = sponsor_roll > opponent_roll ? sponsor : sponsor.opponent

      log "%4s is the high roller." % [victor]

      instructions << Instructions::AwardVictoryPoints.new(
        player: victor,
        amount: 2
      )

      instructions
    end

  end
end
