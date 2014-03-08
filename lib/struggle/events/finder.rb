module Events

  # Finds and instantiates events that are stored in the Events module.
  class Finder

    def initialize(injector)
      @injector = injector
    end

    def find(event_name, action)
      namespace = case action
                  when INFLUENCE, COUP, REALIGNMENT then OperationsEvents
                  when SPACE then SpaceEvents
                  when EVENT then CardEvents
                  else raise ArgumentError, "Invalid action #{action.inspect}"
                  end

      if namespace.constants.include? event_name
        event_class = namespace.const_get(event_name)
        build event_class
      else
        # TODO change this to an error for events and
        # a warn for space/operations once events are implemented
        Instructions::Noop.new(
          label: "Event for #{event_name}:#{action} not found"
        )
      end
    end

    def build(event_class)
      event_instance = event_class.new
      injector.inject(event_instance)
      event_instance
    end

  end
end

