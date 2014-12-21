module Arbitrators
  class OlympicGames < MoveArbitrator

    attr_accessor :player

    def initialize(player:)
      super

      self.player = player
    end

    def accepts?(move)
      correct_player?(move) && enter_or_boycott?(move)
    end

    def enter_or_boycott?(move)
      Instructions::SupportOlympicGames === move.instruction ||
      Instructions::BoycottOlympicGames === move.instruction
    end

    def after_execute(move)
      complete
    end
  end
end
