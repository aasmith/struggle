module Arbitrators
  class AddRestrictedInfluence < MoveArbitrator
    fancy_accessor :player, :influence, :ops_counter

    needs :countries

    # The 'working set' for countries during the execution of this
    # arbitrator.
    #
    # The countries snapshot is used for calculating influence cost as
    # placement of influence changes throughout the play.
    #
    # The countries snapshot is updated when adding influence
    # to a country where influence is already placed. This keeps cost
    # calculation accurate as influence quantity changes.

    attr_accessor :countries_snapshot

    # The state of the countries when the arbitrator is first invoked.
    #
    # Used to detect influence creep.
    #
    # The countries in this list should never be updated.

    attr_accessor :original_countries

    attr_reader :operation_points_to_deduct

    def initialize(player:, influence:, ops_counter:)
      super

      self.player = player
      self.influence = influence
      self.ops_counter = ops_counter
    end

    def before_execute(move)
      country = countries.find(move.instruction.country_name)

      @operation_points_to_deduct =
        add_influence_with_price!(move.instruction.amount, country)
    end

    def after_execute(move)
      country = countries.find(move.instruction.country_name)

      sequence = [country] * @operation_points_to_deduct

      ops_counter.accept(sequence)

      complete if ops_counter.done?
    end

    def accepts?(move)
      correct_player?(move) &&
        valid_country?(move) &&
        valid_influence?(move) &&
        within_spending_limit?(move)
    end

    # Is the target a country where influence can be placed in accordance
    # to geographical restrictions?
    #
    # Satisfy one of:
    #
    #  * Does the player have influence in the country?
    #  * Does the player have influence in a neighboring country?
    #  * Is the country adjacent to the player's superpower?
    #

    def valid_country?(move)
      country   = original_countries.find(move.instruction.country_name)
      neighbors = country.neighbors.lazy.map { |n| original_countries.find(n) }

      return true if country.presence?(player)
      return true if country.adjacent_superpower?(player)
      return true if neighbors.any? { |n| n.presence?(player) }
      return false
    end

    def valid_influence?(move)
      influence == move.instruction.influence
    end

    def within_spending_limit?(move)
      amount  = move.instruction.amount
      country = countries.find(move.instruction.country_name)

      price = price_of_influence(amount, country)

      sequence = [country] * price

      ops_counter.accepts?(sequence)
    end

    # Adds the specified number of influence markers to the country using
    # the current price of influence for each increment.
    #
    # Returns the cost placing influence.
    #
    # Careful, this method has side effects -- actually places influence
    # into the country.

    def add_influence_with_price!(num_markers, country)
      spent = 0

      while num_markers > 0 do
        spent += country.price_of_influence(influence)

        num_markers -= 1
        country.add_influence(influence, 1)
      end

      spent
    end

    # Non-destructive version of 'add_influence_with_price!'.

    def add_influence_with_price(num_markers, country)
      add_influence_with_price!(num_markers, country.dup)
    end

    alias price_of_influence add_influence_with_price

    # Overwrite the countries setter to store a one-time snapshot
    # of the countries. Duplicated so that changes are not written
    # back to the game state.

    undef countries=
      def countries=(countries)
        self.countries_snapshot ||= countries.dup
        self.original_countries ||= countries.dup
      end

    undef countries
    alias countries countries_snapshot

  end

end
