# A basic kind of permission modifier that denies events by name.
#
# Denies the event if it appears as an instruction with the given name, even
# if it is wrapped in an instance of Move.
#
# Denied instructions are skipped by the engine, whereas denied moves are
# treated as an invalid player move.
#
# See the engine for more details.
#
module Modifiers
  module Permission

    class EventPreventer < PermissionModifier

      attr_reader :event_name

      def initialize(event_name:)
        @event_name = event_name
      end

      def allows?(instruction_or_move)
        instruction = instruction_or_move.respond_to?(:instruction) ?
          instruction_or_move.instruction :
          instruction_or_move

        name = instruction.class.name.split("::").last
        allows = name != event_name

        log "EventPreventer for event %s %s %s" % [
          event_name, allows ? "allows" : "prevents", instruction_or_move
        ]

        allows
      end

    end
  end
end

