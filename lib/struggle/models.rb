## EXAMPLE MODELS

### Moves

class Move
  attr_accessor :player, :instruction

  def execute
    instruction.execute
  end

  def executed?
    noimpl
  end
end

class EmptyMove < Move
  def initialize() @executed = false end
  def execute() @executed = true end
  def executed?() @executed end
end

class CardPlay < Move
  attr_accessor :operation, :card
end

### Misc

def noimpl() raise("%s Not Implemented" % [caller_locations.first.to_s]) end

### WorkItem

class WorkItem
  extend Injectible
  extend Arguments

  def initialize(**args)
    @complete = false

    ap = ArgumentProvider.new(self)
    ap.provide(args)

    after_init
  end

  def after_init
  end

  def complete?() @complete end
  def incomplete?() !complete?() end

  private

  def complete
    @complete = true
  end
end


### Instructions

module Instructions
  class Instruction < WorkItem
    def execute
      returning action do
        complete
      end
    end

    def action
      noimpl
    end

    ##
    # Returns +obj+ after calling +block+.
    #
    def returning(obj, &block)
      obj.tap(&block)
    end
  end

  # Used for testing.
  class EmptyInstruction < Instruction
    def action
    end
  end

  # Used for testing.
  class LambdaInstruction < Instruction
    def initialize(&block)
      @block = block
    end

    def action
      @block.call
    end
  end

  class NestingInstruction < Instruction
    def initialize(*instructions)
      @instructions = instructions
    end

    def action
      @instructions
    end
  end

  class AwardVictoryPoints < Instruction
    attr_accessor :player, :amount

    needs :victory_point_track

    def action
      victory_point_track.award(player, amount)
    end
  end

  ##
  # Adds influence to a country, no questions asked.
  #
  # Requires the Countries registry.
  #
  class AddInfluence < Instruction
    arguments :player, :amount, :country

    needs :countries

    def action
      countries.find(country).add_influence(player, amount)
    end
  end
end

### MoveArbitrators

class MoveArbitrator < WorkItem
  def initialize
    super

    @stashed_moves = []
    @executed_moves = []
  end

  def accepts?(move) noimpl end

  def accept(move)
    move.execute
    complete
  end

  def stash(move)
    @stashed_moves.push move
  end

  def execute_stashed_moves
    while move = @stashed_moves.pop do
      move.execute
      @executed_moves.push move
      complete
    end
  end

  def hint() notimpl end
end

class MoveAcceptor < MoveArbitrator
  def accepts?(move) move end # true if move is not nil
end

### Modifiers

class NegativePermissionModifier
  def allows?(move)
    false
  end
end

class StackModifier
  def initialize(*items_to_insert)
    @items_to_insert = items_to_insert
    @seen = false # execute this only once
  end

  def notify(event, move, work_items)
    return if @seen

    work_items.push(*@items_to_insert)

    @seen = true
  end
end
