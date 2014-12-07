module Modifiers
  module Permission
    class PermissionModifier

      def allows?(instruction_or_move)
        raise NotImplementedError
      end

    end
  end
end

