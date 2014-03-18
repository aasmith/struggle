# A counter for tracking the spending of ops points by a single player
# during an action round.
#
# The counter works by calculating all variations of available points and the
# restrictions needed for the player to get those points.
#
# The counter should be consulted with a list of countries the player is
# about to play into using the +accepts?+ method.
#
# If the +accepts?+ method returns true, and the player commits to play
# in those countries, then the +accept+ method should be called to update
# the counter internal state.
#
# This pattern should continue until +done?+ returns true.

class OpsCounter

  # Initializes the counter with the basic starting score (usually the
  # operations points on the card) and any active ops points modifiers.

  def initialize(count, ops_modifiers = [])
    @used_countries = []

    conditionals   = ops_modifiers.select(&:conditional?)
    unconditionals = ops_modifiers.select(&:unconditional?)

    @possibles = { [] => bound(count + sum(unconditionals)) }

    1.upto(conditionals.size) do |i|
      conditionals.combination(i).each do |combination|
        @possibles[combination] = bound(count) +
                                  sum(unconditionals) +
                                  sum(combination)
      end
    end
  end

  # Can the player operate in these countries and not exceed their points
  # allocation?

  def accepts?(countries)
    return false if done?

    @possibles.any? do |ops_modifiers, count|
      all_ops_modifiers_qualify?(countries, ops_modifiers, count)
    end
  end

  # Informs the counter of the player's use of points in these countries.

  def accept(countries)
    raise ArgumentError, "Invalid sequence" unless accepts?(countries)

    @possibles.each do |ops_modifiers, count|
      if all_ops_modifiers_qualify?(countries, ops_modifiers, count)
        @possibles[ops_modifiers] -= countries.size
      else
        @possibles[ops_modifiers] = 0
      end
    end

    @used_countries += countries
  end

  # Have all points been used?

  def done?
    @possibles.all? do |ops_modifiers, count|
      count.zero? || !all_ops_modifiers_qualify?(ops_modifiers, count)
    end
  end

  # Determines how many ops points are available if all points were to
  # be spent in the specified country. This is useful for determining
  # ops points where points need to be known in advance, rather than
  # tracked. (coups)
  #
  # If there are multiple possibilities, then the highest value is
  # returned.
  #
  # This method only makes sense to call on a freshly initialized
  # instance.

  def value_for_country(country)
    values = []

    @possibles.each do |ops_modifiers, count|
      if ops_modifiers.all? { |m| m.qualifies?([country]) }
        values << count
      end
    end

    values.max or fail "No ops value could be found for #{country.inspect}"
  end

  # Returns the number of points that are available without applying
  # any extra geographical modifiers.
  #
  # Useful for the space race.

  def base_value
    @possibles.fetch([])
  end

  def bound(number)
    [[number, 1].max, 4].min
  end

  def sum(ops_modifiers)
    ops_modifiers.map(&:amount).reduce(:+) || 0
  end

  def all_ops_modifiers_qualify?(countries = [], ops_modifiers, count)
    proposed_countries = @used_countries + countries

    ops_modifiers.all? { |m| m.qualifies?(proposed_countries) } &&
      countries.size <= count
  end
end

