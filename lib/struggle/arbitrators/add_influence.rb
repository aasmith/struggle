module Arbitrators

  class AddInfluence < MoveArbitrator
    arguments :player, :influence, :country_names, :total_influence

    attr_reader :remaining_influence

    def after_init
      @remaining_influence = total_influence
    end

    def after_execute(move)
      @remaining_influence -= move.instruction.amount

      complete if @remaining_influence.zero?
    end

    # TODO use minitest assertions?
    def accepts?(move)
      correct_player?(move) &&
        move.instruction.influence == influence &&
        country_names.include?(move.instruction.country_name) &&
        move.instruction.amount <= remaining_influence
    end
  end

end
