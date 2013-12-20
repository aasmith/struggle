class Game
  def initialize
    @engine = Engine.new
  end

  def start
    @engine.work_items.push GameInstructions
  end

  def accept(move)
    @engine.accept move
  end
end

def Instruction(const, *args, &block)
  Instructions.const_get(const).new(*args, &block)
end

def List(*args)
  NestingInstruction.new(*args)
end

alias I Instruction
alias L List

StartingInfluence = List(
  Instruction(AddInfluence, USSR, 1, :syria),
  Instruction(AddInfluence, USSR, 1, :iraq),
  Instruction(AddInfluence, USSR, 3, :north_korea),
  Instruction(AddInfluence, USSR, 3, :east_germany),
  Instruction(AddInfluence, USSR, 1, :finland),

  Instruction(AddInfluence, US, 1, :iran),
  Instruction(AddInfluence, US, 1, :israel),
  Instruction(AddInfluence, US, 1, :japan),
  Instruction(AddInfluence, US, 4, :australia),
  Instruction(AddInfluence, US, 1, :philippines),
  Instruction(AddInfluence, US, 1, :south_korea),
  Instruction(AddInfluence, US, 1, :panama),
  Instruction(AddInfluence, US, 1, :south_africa),
  Instruction(AddInfluence, US, 5, :united_kingdom)
)

DealCards    = Instruction(EmptyInstruction)
EarlyPhase   = Instruction(EmptyInstruction)
MidPhase     = Instruction(EmptyInstruction)
LatePhase    = Instruction(EmptyInstruction)
FinalScoring = Instruction(EmptyInstruction)
GameEnd      = Instruction(LambdaInstruction) { puts "END!!!" }

GameInstructions = List(
  StartingInfluence,
  DealCards,
  EarlyPhase,
  MidPhase,
  LatePhase,
  FinalScoring,
  GameEnd
)

__END__
g = Game.new
g.start
g.accept nil