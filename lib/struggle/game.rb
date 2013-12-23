class Game
  attr_accessor :countries, :deck, :turn, :defcon, :china_card, :space_race,
                :cards, :military_ops, :victory_track, :hands, :phasing_player,
                :discards

  def initialize
    @engine = Engine.new
    @engine.injector = Injector.new(self)

    self.cards = Cards.new
    self.countries = Countries.new(COUNTRY_DATA)

    self.deck = Deck.new
    self.turn = TurnMarker.new
    self.defcon = Defcon.new
    self.china_card = ChinaCard.new
    self.space_race = SpaceRace.new
    self.military_ops = MilitaryOps.new
    self.victory_track = VictoryTrack.new
    self.phasing_player = PhasingPlayer.new

    self.hands = Hands.new

    self.discards = []
  end

  def start
    @engine.add_work_item GameInstructions
  end

  def accept(move)
    @engine.accept move
  end
end

include Instructions

def Instruction(const, **named_args, &block)
  const.new(named_args, &block)
end

def List(*args)
  NestingInstruction.new(*args)
end

alias I Instruction
alias L List

StartingInfluence = List(
  I(AddInfluence, influence: USSR, amount: 1, country: :syria),
  I(AddInfluence, influence: USSR, amount: 1, country: :iraq),
  I(AddInfluence, influence: USSR, amount: 3, country: :north_korea),
  I(AddInfluence, influence: USSR, amount: 3, country: :east_germany),
  I(AddInfluence, influence: USSR, amount: 1, country: :finland),

  I(AddInfluence, influence: US, amount: 1, country: :iran),
  I(AddInfluence, influence: US, amount: 1, country: :israel),
  I(AddInfluence, influence: US, amount: 1, country: :japan),
  I(AddInfluence, influence: US, amount: 4, country: :australia),
  I(AddInfluence, influence: US, amount: 1, country: :philippines),
  I(AddInfluence, influence: US, amount: 1, country: :south_korea),
  I(AddInfluence, influence: US, amount: 1, country: :panama),
  I(AddInfluence, influence: US, amount: 1, country: :south_africa),
  I(AddInfluence, influence: US, amount: 5, country: :united_kingdom),

  #Await(AddInfluence,
  #  player: USSR,
  #  influence: USSR,
  #  countries: EE.countries,
  #  total_influence: 6
  #),

  #Await(AddInfluence,
  #  player: US,
  #  influence: US,
  #  countries: WE.countries,
  #  total_influence: 7
  #)

)

Setup = List(
  Instruction(AddToDeck, phase: :early),
  Instruction(DealCards, target: 8), # DealCards should always take more from
                                     # the discard if the draw deck runs out
  Instruction(ClaimChinaCard, player: USSR, playable: true),
  StartingInfluence
)

# TODO
ExpectMove = List()

UssrActionRound = List(
  Instruction(SetPhasingPlayer, player: USSR),
  ExpectMove
)

UsActionRound = List(
  Instruction(SetPhasingPlayer, player: US),
  ExpectMove
)

ActionRound = List(
  UssrActionRound,
  UsActionRound
)

# TODO
HeadlinePhase = List()

# TODO
EndActionRound = List()

EarlyPhaseTurn = List(
  I(ImproveDefcon),
  I(DealCards, target: 8),
  HeadlinePhase,
  ActionRound, # x6
  EndActionRound, # for certain events to trigger off of
  I(CheckMilitaryOps),
  I(ResetMilitaryOps),
  I(CheckHeldCards), # check no scoring cards
  I(FlipChinaCard), # make it 'playable'
  I(AdvanceTurn)
)

EarlyPhase = List(
  EarlyPhaseTurn,
  EarlyPhaseTurn,
  EarlyPhaseTurn
)

MidPhaseTurn = List(
  I(ImproveDefcon),
  I(DealCards, target: 9),
  HeadlinePhase,
  ActionRound, # x7
  EndActionRound, # for certain events to trigger off of
  I(CheckMilitaryOps),
  I(ResetMilitaryOps),
  I(CheckHeldCards), # check no scoring cards
  I(FlipChinaCard), # make it 'playable'
  I(AdvanceTurn)
)

MidPhase = List(
  Instruction(AddToDeck, phase: :mid),
  MidPhaseTurn,
  MidPhaseTurn,
  MidPhaseTurn,
  MidPhaseTurn
)

LatePhaseTurn = List(
  I(ImproveDefcon),
  I(DealCards, target: 9),
  HeadlinePhase,
  ActionRound, # x7
  EndActionRound, # for certain events to trigger off of
  I(CheckMilitaryOps),
  I(ResetMilitaryOps),
  I(CheckHeldCards), # check no scoring cards
  I(FlipChinaCard), # make it 'playable'
  I(AdvanceTurn)
)

LatePhase = List(
  Instruction(AddToDeck, phase: :late),
  LatePhaseTurn,
  LatePhaseTurn,
  LatePhaseTurn
)

FinalScoring = List()
GameEnd      = Instruction(LambdaInstruction) { puts "END!!!" }

GameInstructions = List(
  Setup,
  EarlyPhase,
  MidPhase,
  LatePhase,
  FinalScoring,
  GameEnd # set game.over = true, game.winner = x
)

if __FILE__ == $0
  eval DATA.read, binding, __FILE__, __LINE__
end

__END__

g = Game.new
g.start
g.accept nil

require 'pp'
pp g
