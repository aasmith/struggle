class Game
  attr_accessor :tasks, :completed_tasks
  attr_accessor :modifiers, :score_modifiers, :permission_modifiers

  def initialize
    self.tasks = []
    self.completed_tasks = []

    self.modifers = []
    self.score_modifiers = []
    self.permission_modifiers = []
  end

  def accept(move)
    move_assigned = false

    while !move_assigned && task do
      execute_task(move)
    end
  end

  def allowed?(move)
  end

  def execute_tasks
  end

end

class MoveContext
  attr_accessor :move, :modifiers

  def initialize
    self.modifiers = Set.new
  end

  def apply
  end

  def add_modifier(m)
    modifiers << m
  end
end

module Conditional
  def allows?(move)
    raise "notimpl"
  end
end

########## EXECUTABLES

class Executable
  def execute
    raise "notimpl"
  end

  def executed?
    raise "notimpl"
  end

  def incomplete?
    !executed?
  end
end

class Move < Executable
  def initialize(name)
    @name = name
    @executed = false
  end

  def execute
    puts "Executed #{name.inspect} move"
    @executed = true
  end

  def executed?
    @executed
  end
end

class IfStatement < Executable
  attr_accessor :cond, :cond_true, :cond_false

  def initialize(cond, cond_true, cond_false)
    self.cond = cond
    self.cond_true = cond_true
    self.cond_false = cond_false
  end

  def execute
    cond.call ? cond_true : cond_false
  end
end

an_if = IfStatement.new(
  lambda { 3 > 2 },
  [Move.new("if-true!")],
  [Move.new("if-false!")]
)


######## EXPECTATIONS

class State < Executable

  attr_reader :moves

  def initialize
    @moves = []
  end

  def allows?(move)
    raise "notimpl"
  end

  def update(move)
    raise "notimpl"
  end

  def stash(move)
    @moves << move
  end

  def execute
  end

  def executed?
    todo
  end


end



