## EXAMPLE MODELS

### Instructions

module Instructions

  # Used for testing.
  class EmptyInstruction < Instruction
    def action
    end
  end

  # Used for testing.
  class LambdaInstruction < Instruction
    def initialize(**_, &block)
      super()

      @block = block
    end

    def action
      @block.call
    end
  end

  class If < Instruction
    def initialize(cond, cond_true, cond_false)
      super()
    end

    def action
      NestingInstruction.new(*cond ? cond_true : cond_false)
    end
  end
end

class Matcher
  attr_reader :item_class, :anything

  def initialize(item_class: nil, anything: false)
    self.item_class = item_class
    self.anything = anything
  end

  def matches?(item)
    anything || item_class === item
  end
end

# alias
Match = Matcher

### Modifiers

# TODO: roll these existing modifiers into observers.

##
# Always says no to every work item.
#
# Used for testing.
#
class NegativePermissionModifier
  def allows?(work_item)
    false
  end
end

# Used in testing
class StackModifier
  def initialize(*items_to_insert)
    @items_to_insert = items_to_insert
    @executed = false # execute this only once
  end

  def notify(event, move, work_items)
    return if @executed

    work_items.push(*@items_to_insert)

    @executed = true
  end
end


# Prevents a WorkItem from being executed.
#
# If the WorkItem is a Move, then the move is rejected, allowing the player
# to make an alternative move.
#
# If the WorkItem is an Instruction, then the instruction execution is
# skipped.
#
class PermissionModifier
  extend Injectible

  def allows?(work_item)
    raise NotImplementedError
  end
end

