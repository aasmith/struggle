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

### Modifiers

##
# Always says no to every move.
#
# Used for testing.
#
class NegativePermissionModifier
  def allows?(move)
    false
  end
end

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


class PermissionModifier
  extend Injectible

  def allows?(move)
    raise NotImplementedError
  end
end

