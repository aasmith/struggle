class Game
  attr_accessor :countries, :deck, :turn, :defcon, :china_card, :space_race,
                :cards, :military_ops, :victory_track, :hands, :phasing_player,
                :current_cards, :discards, :removed, :limbo, :victory, :rng

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

    self.rng = Random.new
  end

  def start
    @engine.add_work_item GameInstructions
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

  def observers
    @engine.observers
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

# Markers
module Instructions
  ActionRoundEnd  = Class.new(Instructions::Noop)
  ActionRoundsEnd = Class.new(Instructions::Noop)
end

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

# These are called more than once, so make sure a list of new instances
# are returned each time.

def PlayerActionRound(player:)
  List(
    # TODO might need this to comply with 6.1.1 -- capturing country markers
    # that are in place at the begining of the player's AR
    #
    # sets game.countries_snapshot = game.countries.dup
    #
    # the AddRestrictedInfluence arbitrator can access this var instead.
    #
    # Instruction(:SnapshotCountries)

    Instruction(:SetPhasingPlayer, player: player),
    Arbitrator(:CardPlay, player: player),
    Instruction(:DisposeCurrentCards),
    Instruction(:ActionRoundEnd)
  )
end

def ActionRound
  List(
    PlayerActionRound(player: USSR),
    PlayerActionRound(player: US)
  )
end

# TODO
def HeadlinePhase
  List()
end

def Turn(phase:)
  cards  = { early: 8, mid: 9, late: 9 }
  rounds = { early: 6, mid: 7, late: 7 }

  List(
    I(:ImproveDefcon),
    I(:DealCards, target: cards[phase]),
    HeadlinePhase(),

    *rounds[phase].times.map { ActionRound() },

    I(:ActionRoundsEnd), # for certain events to trigger off of
    I(:CheckMilitaryOps),
    I(:ResetMilitaryOps),
    I(:CheckHeldCards), # check no scoring cards
    I(:FlipChinaCard), # make it 'playable'
    I(:AdvanceTurn)
  )
end

def Phase(phase)
  List(
    # Early phase cards are dealt before the phase begins.
    *phase != :early ? Instruction(:AddToDeck, phase: phase) : nil,
    Turn(phase: phase),
    Turn(phase: phase),
    Turn(phase: phase)
  )
end

# TODO Award the holder of The China Card at the end of Turn 10 with 1 VP.
AwardChinaCardHolder = List()

FinalScoring = List(
  AwardChinaCardHolder
)

GameInstructions = List(
  Setup,
  Phase(:early),
  Phase(:mid),
  Phase(:late),
  FinalScoring, # set a winner here if applicable
  I(:EndGame)
)

