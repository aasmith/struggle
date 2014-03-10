require "helper"

require "struggle/game"

# Basic catch-all tests for events.
class EventsTest < Struggle::Test

  def setup
    # Events can be injected with anything.
    @game = Game.new
  end

  CARD_DUMPERS = [
    Instructions::Discard,
    Instructions::Remove,
    Instructions::Limbo,
  ]

  def test_all_events_dump_card
    Events::CardEvents.constants.each do |event_class_name|

      event_class = Events::CardEvents.const_get(event_class_name)

      event = event_class.new
      @game.injector.inject(event)

      instructions = event.action

      # Ignore the event if it doesnt exist yet
      next if instructions.all? { |i| Instructions::Noop === i }

      *_, last = instructions

      # The last instruction should probably be some kind of card dump
      # of the card that triggered the event.
      #
      # This wont always be true...

      assert_includes CARD_DUMPERS, last.class

      name = event_class.name.split("::").last

      assert_equal name, last.card_ref, "Event should dump own card"
    end
  end
end
