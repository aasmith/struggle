require "set"

#
# Tracks events in effect. Emulates the 'events in effect' box
# that was present on the board for the first edition printing.
#

class EventsInEffect

  include Enumerable

  def initialize(events = [])
    @events = Set.new(events)
  end

  def add(event)
    @events.add event
  end

  def remove(event)
    @events.delete event
  end

  def each(&block)
    @events.each &block
  end

end

