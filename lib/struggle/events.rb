# Events are specific instructions used to construct events such as
# card events, space race events and the china card bonus.
module Events end

require_relative "events/card_events"
require_relative "events/space_events"
require_relative "events/operations_events"

require_relative "events/finder"
