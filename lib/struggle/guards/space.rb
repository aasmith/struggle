module Guards

  # Ensures the given player hasn't already exceeded their space race cap.
  #
  # Also checks to see if the card op value is enough to qualify.

  class Space < Guard

    needs :observers, :cards, :space_race

    def ops
      card = cards.find_by_ref(card_ref)
      mods = observers.ops_modifiers_for_player(player)

      counter = OpsCounter.new(card.ops!, mods)
      counter.base_value
    end

    def allowed_attempts
      mods    = observers.space_race_modifiers(player: player)
      mod_sum = mods.map(&:amount).reduce(:+) || 0

      1 + mod_sum
    end

    def has_remaining_attempts?
      space_race.attempts(player) < allowed_attempts
    end

    def meets_ops_entry_requirement?
      entry_requirement = space_race.entry_requirement(player)

      ops >= entry_requirement.min_ops
    end

    def completed_space_race?
      space_race.complete? player
    end

    def allows?
      !completed_space_race? &&
        has_remaining_attempts? &&
        meets_ops_entry_requirement?
    end
  end

end
