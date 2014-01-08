class Engine

  attr_accessor :injector

  def initialize
    @work_items = Stack.new

    @history = []

    @permission_modifiers = []
    @stack_modifiers = []

    # Provide a default injector that does nothing.
    self.injector = NullInjector.new(nil)
  end

  def add_work_item(*items)
    @work_items.push(*items)
  end

  ## Modifiers

  def add_permission_modifier(mod)
    @permission_modifiers << mod
  end

  def permitted?(move)
    @permission_modifiers.all? { |mod| mod.allows? move }
  end

  def add_stack_modifier(mod)
    @stack_modifiers << mod
  end

  def notify_stack_modifiers(move)
    @stack_modifiers.each do |mod|
      mod.notify(:on, move, @work_items)
    end
  end

  def accept(move)
    while work_item = @work_items.pop do

      injector.inject(work_item)

      if Instructions::Instruction === work_item
        results = [*work_item.execute]

        @work_items.push(*results) if results.all? { |r| WorkItem === r }

      elsif Arbitrators::MoveArbitrator === work_item
        work_item.execute_stashed_moves

        if work_item.complete?
          next

        elsif move && permitted?(move) && work_item.accepts?(move)

          @work_items.push work_item

          stack_modified = @work_items.stack_changed? do
            notify_stack_modifiers(move)
          end

          if stack_modified
            work_item.stash move
            break
          else
            @work_items.pop
            work_item.accept move
            move = nil
          end

        else
          @work_items.push work_item
          break

        end

      else
        raise "unknown item #{work_item.inspect}"

      end
    end
  end

  ##
  # Execute any ioutstanding items on the stack and then peek.
  #
  def peek
    accept nil # Pass in a false move to push the game along
    peek!
  end

  ##
  # Peek without first trying to execute the stack.
  #
  def peek!
    @work_items.peek
  end

end



class WorkItemAdapter
  def initialize(item)
    @item = item
  end

  def execute_stashed_moves
  end

  def complete?
  end

  def accepts?(move)
  end

  def execute
  end

  def results
  end
end

__END__
class Game
  def initialize
    @expectations = [] # stack

    @score_modifiers = []
    @permission_modifiers = []
    @modifiers = []
  end

  ### Expectations

  def expectation
    # return the first unsatisfied expectation
    @expectations.detect(&:unsatisfied?)
  end

  alias requirement expectation

  def add_expectations(*expectations)
    @expectations.unshift(*expectations)
  end

  alias add_requirement add_expectations

  def satisfy_expectations
    while exp = unsatisfied_expectation_with_stashed_moves do
      exp.unexecuted_moves.each do |move|
        exp.update move
        move.execute
      end
    end
  end

  def unsatisfied_expectation_with_stashed_moves
    exp = @expectations.detect(&:unsatisfied?)

    exp && exp.unexecuted_moves? ? exp : nil
  end

  ### Move-oriented methods

  def accept(move)
    apply_score_modifiers(move)

    if allowed?(move)
      expectation.stash(move)

      add_expectations *generate_expectations_for(move)
    end

    satisfy_expectations
  end

  def generate_expectations_for(move)
    publish(:on, move)
  end

  def allowed?(move)
    expectation.allows?(move) && permitted_by_modifiers?(move)
  end

  ### Modifiers

  def apply_score_modifiers(move)
    @score_modifiers.each do |mod|
      mod.modify(move)
    end
  end

  def permitted_by_modifiers?(move)
    @permission_modifiers.all? do |mod|
      mod.allows?(move)
    end
  end

  def add_score_modifier(modifier)
    @score_modifiers << modifier
  end

  def add_permission_modifier(modifier)
    @permission_modifiers << modifier
  end

  def add_modifier(modifier)
    @modifiers << modifier
  end

  ### Events

  def publish(event, move)
    new_expectations = @modifiers.map do |mod|
      mod.notify(event, move)

      # collect any new expectations that may have been generated.
      # TODO may need some kind of priority for ordering these if multiple
      # modifiers add expectations.
      mod.new_expectations
    end

    if new_expectations.size > 1
      warn "Multiple modifiers added expectations. TODO: Add priority?"
    end

    new_expectations.flatten
  end
end



US = Class.new

class Country
  def initialize(n); @n = n; @inf = 0 end
  def add_influence(side, amount); @inf += 1; end
end

__END__

Actual game loop:

while !g.over? do
  p g.log # what happened since the last poll
  p g.next_expectation # what the game needs to advance
  g.accept(move) # our chance to advance the game
end
