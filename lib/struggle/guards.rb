# Guards try to prevent the game from getting into an unresolvable state.
# For instance, blocking a card play for coup when there is nowhere on the
# board the player could possibly coup.

module Guards; end

require_relative "guards/coup"
require_relative "guards/influence"
require_relative "guards/realignment"
require_relative "guards/space"
