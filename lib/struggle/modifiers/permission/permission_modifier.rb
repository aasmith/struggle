module Modifiers
  module Permission
    class PermissionModifier

      extend Injectable

      def allows?(instruction_or_move)
        raise NotImplementedError
      end

    end
  end
end

