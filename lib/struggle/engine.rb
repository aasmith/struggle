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
    d "ENTERING STACK LOOP"

    while work_item = @work_items.pop do

      debug_start_of_iteration(work_item, move)

      injector.inject(work_item)

      if Instruction === work_item
        results = [*work_item.execute]

        @history << work_item

        if !results.empty? && results.all? { |r| WorkItem === r }
          @work_items.push(*results)
        end

      elsif MoveArbitrator === work_item
        results = [*work_item.execute_stashed_moves]

        if !results.empty? && results.all? { |r| WorkItem === r }
          @work_items.push(*results)

        elsif work_item.complete?
          @history << work_item
          next

        elsif move && permitted?(move) && work_item.accepts?(move)

          injector.inject(move.instruction)

          @work_items.push work_item

          stack_modified = @work_items.stack_changed? do
            notify_stack_modifiers(move)
          end

          if stack_modified
            # stack has been modified, save the move inside
            # the current work item, and continue the loop again
            # from the top.
            work_item.stash move
          else
            results = work_item.accept(move)

            if !results.empty? && results.all? { |r| WorkItem === r }
              @work_items.push(*results)
            end
          end

          # Move has been used for this iteration, don't leave it lying
          # around for the next one.
          move = nil

        # Not able to accept this move, put the item back and stop the loop.
        else
          @work_items.push work_item
          break

        end

      else
        raise "unknown item #{work_item.inspect}"

      end

      debug_end_of_iteration(work_item)

    end

    d "LEAVING STACK LOOP"
  end

  ##
  # Execute any outstanding items on the stack and then peek.
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

  private

  def d(*msg)
    puts(*msg) if DEBUG_ENGINE
  end

  def debug_start_of_iteration(work_item, move)
    if DEBUG_ENGINE
      puts
      puts "START iteration"
      puts "---------------------------"
      puts "top of stack is"

      pp work_item

      if move
        puts "move is"
        pp move
      else
        puts "no move present"
      end

      puts "---------------------------"
      puts
    end
  end

  def debug_end_of_iteration(work_item)
    if DEBUG_ENGINE
      puts "end of iteration, work_item:"
      pp work_item
      puts "END iteration"
    end
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
