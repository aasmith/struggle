class Engine

  attr_accessor :injector

  attr_reader :permission_modifiers

  def initialize
    @work_items = Stack.new

    @history = []
    @observers = []

    @permission_modifiers = []
    @stack_modifiers = []

    # Provide a default injector that does nothing.
    self.injector = NullInjector.new(nil)
  end

  def add_work_item(*items)
    @work_items.push(*items)
  end

  ## Observers

  def add_observer(observer)
    @observers << observer
  end

  def notify_observers(work_item)
    @observers.each { |o| o.notify(work_item) }
  end

  def observers
    Observers.new(@observers)
  end

  ## Modifiers

  def add_permission_modifier(mod)
    @permission_modifiers << mod
  end

  def remove_permission_modifier(mod)
    @permission_modifiers.delete mod
  end

  def permitted?(item)
    @permission_modifiers.all? do |mod|
      injector.inject mod
      mod.allows? item
    end
  end

  def add_stack_modifier(mod)
    @stack_modifiers << mod
  end

  def notify_stack_modifiers(move)
    @stack_modifiers.each do |mod|
      # TODO Change this interface. Put the stuff into @work_items ourselves.
      mod.notify(:on, move, @work_items)
    end
  end

  def accept(move)
    d "ENTERING STACK LOOP"

    while work_item = @work_items.pop do

      debug_start_of_iteration(work_item, move)

      injector.inject(work_item)
      injector.inject(move)

      if Instruction === work_item

        if permitted?(work_item)

          results = package_results work_item.execute

          notify_observers(work_item)

          @history << work_item

          push_onto_stack(*results) if all_work_items? results

        end

      elsif MoveArbitrator === work_item
        results = package_results work_item.execute_next_stashed_move

        if all_work_items? results
          push_onto_stack(*results)

        elsif work_item.complete?
          @history << work_item

        elsif move && permitted?(move) && work_item.accepts?(move)

          injector.inject(move.instruction)

          push_onto_stack work_item

          stack_modified = @work_items.monitor do
            notify_stack_modifiers(move)
          end

          if stack_modified
            # stack has been modified, save the move inside
            # the current work item, and continue the loop again
            # from the top.
            work_item.stash move
          else
            results = package_results work_item.accept(move)

            push_onto_stack(*results) if all_work_items? results
          end

          # Move has been used for this iteration, don't leave it lying
          # around for the next one.
          move = nil

        # Not able to accept this move, put the item back and stop the loop.
        else
          if move
            log "The move by %s was rejected" % [move.player]
            log move
          end

          push_onto_stack work_item
          break

        end

      else
        raise "unknown item #{work_item.inspect}"

      end

      debug_end_of_iteration(work_item)

    end

    d "LEAVING STACK LOOP"
  end

  def all_work_items?(items)
    items = [*items]

    !items.empty? && items.all? { |r| WorkItem === r }
  end

  def push_onto_stack *stuff
    @work_items.push(*stuff)
  end

  # Takes a result and assures it comes back in a neatly packaged array.
  def package_results(results)
    [*results].flatten
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

