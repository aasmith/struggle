
# A simple wrapper around all observers. Encapsulates the discovery of
# different types of (active) observers.

class Observers
  def initialize(observers)
    @observers = observers.select(&:active?)
  end

  def ops_modifiers_for_player(player)
    @observers.select { |o| OpsModifier === o && o.player == player }
  end

  # Returns all active DieRollModifiers that match given player, country
  # and purpose (coup, influence, etc)
  def die_roll_modifiers(player:, country:, purpose:)
    # TODO
    []
  end
end

