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

      if namespace.constants.include? event_name.to_sym
        event_class = namespace.const_get(event_name)
        build event_class
      else
        if action == EVENT
          # Event lookup should never fail.
          fail "Event for #{event_name}:#{action} not found"
        else
          warn "Event for #{event_name}:#{action} not found"
        end
      end
    end

    def build(event_class)
      event_instance = event_class.new
      @injector.inject(event_instance)
      event_instance
    end

  end
end

