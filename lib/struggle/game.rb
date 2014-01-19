class Game
  attr_accessor :countries, :deck, :turn, :defcon, :china_card, :space_race,
                :cards, :military_ops, :victory_track, :hands, :phasing_player,
                :current_cards, :discards, :removed, :limbo, :victory

  def initialize
    @engine = Engine.new
    @engine.injector = Injector.new(self)

    self.cards = Cards.new
    self.countries = Countries.new(COUNTRY_DATA)

    self.deck = Deck.new
    self.turn = TurnMarker.new
    self.defcon = Defcon.new
    self.victory = Victory.new
    self.china_card = ChinaCard.new
    self.space_race = SpaceRace.new
    self.military_ops = MilitaryOps.new
    self.victory_track = VictoryTrack.new
    self.phasing_player = PhasingPlayer.new

    self.hands = Hands.new

    # Cards that are currently being played.
    self.current_cards = Set.new

    self.discards = Set.new
    self.removed = Set.new

    # Limbo is for cards that stay on the board but get put into the discard
    # pile once they are cancelled (i.e. Shuttle Diplomacy).
    self.limbo = Set.new
  end

  def start
    @engine.add_work_item GameInstructions

    @engine.add_permission_modifier ChinaCardPermissionModifier.new
    @engine.add_permission_modifier SpaceRacePermissionModifier.new
  end

  def accept(move)
    @engine.accept move
  end

  def hint
    @engine.peek
  end

  def hand(player)
    hands.get(player)
  end
end

def Instruction(const, **named_args, &block)
  Instructions.const_get(const).new(named_args, &block)
end

def List(*args)
  Instructions::NestingInstruction.new(*args)
end

def Arbitrator(const, **named_args, &block)
  Arbitrators.const_get(const).new(named_args, &block)
end

module ContextHelpers
  class ContextHelper
    extend Injectible

    def value
      raise "impl"
    end
  end

  class EastEuropeanCountries < ContextHelper

    needs :countries

    def value
      countries.
        select { |c| c.in?(EasternEurope) }.
        map    { |c| c.name }
    end
  end

  class WestEuropeanCountries < ContextHelper

    needs :countries

    def value
      countries.
        select { |c| c.in?(WesternEurope) }.
        map    { |c| c.name }
    end
  end
end

alias I Instruction
alias L List

StartingInfluence = List(
  I(:AddInfluence, influence: USSR, amount: 1, country_name: "Syria"),
  I(:AddInfluence, influence: USSR, amount: 1, country_name: "Iraq"),
  I(:AddInfluence, influence: USSR, amount: 3, country_name: "North Korea"),
  I(:AddInfluence, influence: USSR, amount: 3, country_name: "East Germany"),
  I(:AddInfluence, influence: USSR, amount: 1, country_name: "Finland"),

  I(:AddInfluence, influence: US, amount: 1, country_name: "Iran"),
  I(:AddInfluence, influence: US, amount: 1, country_name: "Israel"),
  I(:AddInfluence, influence: US, amount: 1, country_name: "Japan"),
  I(:AddInfluence, influence: US, amount: 4, country_name: "Australia"),
  I(:AddInfluence, influence: US, amount: 1, country_name: "Philippines"),
  I(:AddInfluence, influence: US, amount: 1, country_name: "South Korea"),
  I(:AddInfluence, influence: US, amount: 1, country_name: "Panama"),
  I(:AddInfluence, influence: US, amount: 1, country_name: "South Africa"),
  I(:AddInfluence, influence: US, amount: 5, country_name: "United Kingdom"),

  Arbitrator(:AddInfluence,
    player: USSR,
    influence: USSR,
    country_names: ContextHelpers::EastEuropeanCountries.new,
    total_influence: 6
  ),

  Arbitrator(:AddInfluence,
    player: US,
    influence: US,
    country_names: ContextHelpers::WestEuropeanCountries.new,
    total_influence: 7
  )
)

Setup = List(
  Instruction(:AddToDeck, phase: :early),
  Instruction(:DealCards, target: 8),
  Instruction(:ClaimChinaCard, player: USSR, playable: true),
  StartingInfluence
)

UssrActionRound = List(
  # TODO might need this to comply with 6.1.1 -- capturing country markers
  # that are in place at the begining of the player's AR
  #
  # sets game.countries_snapshot = game.countries.dup
  #
  # the AddRestrictedInfluence arbitrator can access this var instead.
  #
  # Instruction(:SnapshotCountries)

  Instruction(:SetPhasingPlayer, player: USSR),
  Arbitrator(:CardPlay, player: USSR),
  Instruction(:DisposeCurrentCards)
)

UsActionRound = List(
  # TODO see above
  # Instruction(:SnapshotCountries)

  Instruction(:SetPhasingPlayer, player: US),
  Arbitrator(:CardPlay, player: US),
  Instruction(:DisposeCurrentCards)
)

ActionRound = List(
  UssrActionRound,
  UsActionRound
)

# TODO
HeadlinePhase = List()

# TODO
EndActionRounds = List()

EarlyPhaseTurn = List(
  I(:ImproveDefcon),
  I(:DealCards, target: 8),
  HeadlinePhase,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  EndActionRounds, # for certain events to trigger off of
  I(:CheckMilitaryOps),
  I(:ResetMilitaryOps),
  I(:CheckHeldCards), # check no scoring cards
  I(:FlipChinaCard), # make it 'playable'
  I(:AdvanceTurn)
)

EarlyPhase = List(
  EarlyPhaseTurn,
  EarlyPhaseTurn,
  EarlyPhaseTurn
)

MidPhaseTurn = List(
  I(:ImproveDefcon),
  I(:DealCards, target: 9),
  HeadlinePhase,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  EndActionRounds, # for certain events to trigger off of
  I(:CheckMilitaryOps),
  I(:ResetMilitaryOps),
  I(:CheckHeldCards), # check no scoring cards
  I(:FlipChinaCard), # make it 'playable'
  I(:AdvanceTurn)
)

MidPhase = List(
  Instruction(:AddToDeck, phase: :mid),
  MidPhaseTurn,
  MidPhaseTurn,
  MidPhaseTurn,
  MidPhaseTurn
)

LatePhaseTurn = List(
  I(:ImproveDefcon),
  I(:DealCards, target: 9),
  HeadlinePhase,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  ActionRound,
  EndActionRounds, # for certain events to trigger off of
  I(:CheckMilitaryOps),
  I(:ResetMilitaryOps),
  I(:CheckHeldCards), # check no scoring cards
  I(:FlipChinaCard), # make it 'playable'
  I(:AdvanceTurn)
)

LatePhase = List(
  Instruction(:AddToDeck, phase: :late),
  LatePhaseTurn,
  LatePhaseTurn,
  LatePhaseTurn
)

FinalScoring = List()
#GameEnd      = Instruction(LambdaInstruction) { puts "END!!!" }

GameInstructions = List(
  Setup,
  EarlyPhase,
  MidPhase,
  LatePhase,
  FinalScoring, # set a winner here if applicable
  I(:EndGame)
)

