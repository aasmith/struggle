module Guards
  class Realignment < Guard

    needs :countries, :defcon, :observers

    # All countries where the opponent has influence.

    def realignable_countries
      countries.select do |country|
        country.presence?(player.opponent)
      end
    end

    # All countries where a realignment by the player is disallowed.

    def restricted_countries
      # TODO check permission modifiers that prevent realignments
      # NOTE dont consider merging this class with the Coup guard
      #      until permission mod checking is complete.

      countries.select do |country|
        defcon.affects?(country)
      end
    end

    # Can the +player+ execute a realignment somewhere?

    def allows?
      !(realignable_countries - restricted_countries).empty?
    end

  end
end
