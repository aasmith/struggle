module Guards

  # This class doesnt really care about anything until we start
  # checking permission modifiers.

  class Influence < Guard

    # TODO check permission modifiers for AddRestrictedInfluence
    # (hint: it's Chernobyl)
    #
    # Other than permission modifiers, I can't think of anything else
    # that could prevent a player from placing influence at least
    # somewhere on the board.

    def allows?
      true
    end

  end
end
