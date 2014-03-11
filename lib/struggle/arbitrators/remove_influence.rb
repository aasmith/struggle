module Arbitrators

  class RemoveInfluence < ChangeInfluence
    def accepts?(move)
      Instructions::RemoveInfluence === move.instruction && super
    end
  end

end
