module Instructions
  class ScoreRegion < Instruction

    include Scoring

    fancy_accessor :region_name, :presence, :domination, :control

    needs :countries, :observers

    def initialize(region_name:, presence:, domination:, control:)
      super

      self.region_name = region_name
      self.presence    = presence
      self.domination  = domination
      self.control     = control
    end

    def action
      instructions = []

      modifiers = observers.scoring_modifiers

      modified_countries = apply_scoring_modifiers(
        modifiers, countries.select { |c| c.in?(region_name) }
      )

      region = Region.new(modified_countries)

      if region_name == Europe && region.controlled?
        controller = region.controlled_by?(USSR) ? USSR : US

        instructions << Instructions::DeclareWinner.new(
          player: controller,
          reason: "Control of Europe"
        )

        log "%s controls Europe and gets Automatic Victory" % controller

      else

        vp_award = region.score(
          presence:   presence,
          domination: domination,
          control:    control
        )

        if vp_award
          instructions << Instructions::AwardVictoryPoints.new(
            player: vp_award.player,
            amount: vp_award.amount
          )

          log "%s gets %s VP in #{region_name}" % [
            vp_award.player, vp_award.amount
          ]

        else
          log "Both sides draw in scoring #{region_name}"

        end
      end

      instructions
    end

  end
end
