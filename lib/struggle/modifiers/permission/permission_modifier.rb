module Modifiers
  module Permission
    class PermissionModifier

      extend Injectible

      def allows?(instruction_or_move)
        raise NotImplementedError
      end

    end
  end
end

