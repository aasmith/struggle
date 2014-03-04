module Instructions
  class AttemptSpaceRace < Instruction

    fancy_accessor :player, :card_ref

    needs :die, :space_race

    def initialize(player:, card_ref:)
      super

      self.player = player
      self.card_ref = card_ref
    end

    def action
      instructions = []

      instructions << Discard.new(card_ref: card_ref)

      roll = die.roll
      roll_range = space_race.entry_requirement(player).roll_range

      log "Roll to advance must be between %s and %s, inclusive." % [
        roll_range.begin, roll_range.end
      ]

      log "%4s rolls %s on space race." % [player, roll]

      space_race.attempt(player) # Register the attempt

      if roll_range.include? roll
        log "%4s advances in the space race." % player

        instructions << Instructions::AdvanceSpaceRace.new(
          player: player,
          amount: 1
        )

      else
        log "%4s fails to advance in the space race." % player
      end

      instructions
    end

  end
end

