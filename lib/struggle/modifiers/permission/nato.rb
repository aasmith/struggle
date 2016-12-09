module Modifiers::Permission
  class Nato < PermissionModifier

    needs :events_in_effect, :countries

    def allows?(instruction_or_move)
      return true unless Move === instruction_or_move

      move = instruction_or_move
      instruction = move.instruction

      return true unless move.player == USSR

      return true unless Instructions::Coup === instruction ||
                         Instructions::Realignment === instruction

      return true unless protected_countries.map(&:name).
                         include?(instruction.country_name)

      return false
    end

    def protected_countries
      france = countries.find("France")
      west_germany = countries.find("West Germany")

      cancels = []
      cancels << france       if events_in_effect.include?("DeGaulleLeadsFrance")
      cancels << west_germany if events_in_effect.include?("WillyBrandt")

      us_controlled_in_eu = countries.select do |c|
        c.controlled_by?(US) && c.in?(Europe)
      end

      us_controlled_in_eu - cancels
    end

  end
end
