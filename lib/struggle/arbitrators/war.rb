module Arbitrators

  # A War arbitrator expects a user input of a given war
  # instruction with a valid country.
  #
  #--
  #
  # TODO Generalize to PlayerDecision?
  #
  # This could be abstracted in the future to accommodate
  # wider ranges of user input in the form of an instruction
  # name and a list of arguments and their allowed values.
  #
  class War < MoveArbitrator

    fancy_accessor :player, :country_names, :war_instruction

    def initialize(player:, country_names:, war_instruction:)
      super

      self.player = player
      self.country_names = country_names
      self.war_instruction = war_instruction
    end

    def accepts?(move)
      correct_player?(move) && war_instruction?(move) && valid_country?(move)
    end

    def war_instruction?(move)
      war_instruction === move.instruction
    end

    def valid_country?(move)
      country_names.include? move.instruction.country_name
    end

  end

end
