module Arbitrators

  class AddInfluence < ChangeInfluence
    def accepts?(move)
      Instructions::AddInfluence === move.instruction && super
    end
  end

end
