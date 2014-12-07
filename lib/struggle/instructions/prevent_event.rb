module Instructions

  class PreventEvent < Instruction

    fancy_accessor :event_name

    needs :engine

    def action
      engine.add_permission_modifier(
        Modifiers::Permission::EventPreventer.new(
          event_name: event_name
        )
      )
    end

  end

end

