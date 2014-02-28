module Guards
  class Coup < Guard

    needs :countries, :defcon, :observers

    # All countries where the opponent has influence.

    def coupable_countries
      countries.select do |country|
        country.presence?(player.opponent)
      end
    end

    # All countries where a coup by the player is disallowed.

    def restricted_countries
      # TODO check permission modifiers that prevent coups

      countries.select do |country|
        defcon.affects?(country)
      end
    end

    # Can the given player coup anywhere given current state

    def allows?
      !(coupable_countries - restricted_countries).empty?
    end

  end
end
