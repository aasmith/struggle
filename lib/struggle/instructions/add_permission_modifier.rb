module Instructions
  class AddPermissionModifier < Instruction

    fancy_accessor :modifier_name

    needs :engine

    def initialize(modifier_name:)
      self.modifier_name = modifier_name
    end

    def action
      modifier = Modifiers::Permission.const_get modifier_name, false

      engine.add_permission_modifier(modifier.new)
    end
  end
end
