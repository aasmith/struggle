class GuardResolver

  def initialize(injector)
    @injector = injector
  end

  def resolve(move)
    action = move.instruction.card_action

    unless OPERATIONS.include? action
      raise ArgumentError, "Invalid action #{action.inspect}"
    end

    guard = Guards.const_get(action.to_s.capitalize).new(move)

    injector.inject(guard)

    guard
  end

end
