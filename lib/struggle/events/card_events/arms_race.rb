module Events
  module CardEvents

    class ArmsRace < Instruction

      needs :military_ops, :defcon, :phasing_player

      def action
        instructions = []

        unless vp_award.zero?
          instructions << Instructions::AwardVictoryPoints.new(
            player: phasing_player,
            amount: vp_award
          )
        end

        instructions << Instructions::Discard.new(
          card_ref: "ArmsRace"
        )

        instructions
      end

      def vp_award
        player   = phasing_player.player
        opponent = phasing_player.player.opponent

        more = military_ops.value(player) >  military_ops.value(opponent)
        met  = military_ops.value(player) >= defcon.value

        if    more && met then 3
        elsif more        then 1
        else  0
        end
      end

    end

  end
end
