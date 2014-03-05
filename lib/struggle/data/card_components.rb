# Notes
# -----
#
# Because of dependence on a number of variables, some lambdas will need to
# become a first-class object with injection and an execute method.
# Particularly those related to Wars, and VP awards.
#
# Need a single point of truth for the removal of modifiers, this data is
# currently repeated in several places.
#
# TurnEnd is assumed to fire upon advancement of the turn marker (4.5 H).
#
# Cards that are instead returned to the discard pile if the opponent triggers
# the event but the event does not occur (See 5.2 example 4):
#
#  - Star Wars
#  - Kitchen Debates
#  - Our Man in Tehran (optional card)
#
# TODO RE: DISCARD/REMOVE/LIMBO:
#
# The removing/discarding/limboing of a card as part of event play must be
# expressed as an instruction in the list of instructions that make up an
# event. This is because only the event instructions themselves can
# communicate the concept of an event being triggered and executing through
# to its end. Certain cards, such as those above may have an event that is not
# fully executed.
#
# See Decolonization, TrumanDoctrine, StarWars and ShuttleDiplomacy for
# examples of cards that manage their own disposal. TODO All cards need to do
# this.
#
# TODO does this mean the remove_after_event and other fields should be
# remvoed from the Card class?
#

def all_influence(player)
  lambda { |c| c.influence(player) }
end

on_turn_end         = Match.new(item_class: TurnEnd)
on_action_round_end = Match.new(item_class: ActionRoundEnd)

Decolonization = [
  Arb::AddInfluence(
    player: USSR,
    influence: USSR,
    limit_per_country: 1,
    countries: [Africa, SoutheastAsia],
    total_influence: 4),
  Discard(Decolonization)
]

TrumanDoctrine = [
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: lambda { Europe.uncontrolled },
    limit_per_country: all_influence(USSR),
    total_countries: 1
  ),
  Remove(TrumanDoctrine)
]

SuezCrisis = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [France, UnitedKingdom, Israel],
    limit_per_country: 2,
    total_influence: 4
  )
]

SocialistGovernments = [
  PreventedBy(IronLady),
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [WesternEurope],
    limit_per_country: 2,
    total_influence: 3
  )
]

EastEuropeanUnrest = [
  # TODO Use an If here for determining early/mid/late actions
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [EasternEurope],
    limit_per_country: 1,
    total_countries: 3,
    phase: [Early, Mid]
  ),
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [EasternEurope],
    limit_per_country: 2,
    total_countries: 3,
    phase: [Late]
  )
]

IndependentReds = [
  # TODO Rethink this.
  # Maybe Either(Instruction(countryA), Instruction(countryB), ...) ?
  Arb::AddInfluence(
    player: US,
    influence: US,
    countries: [Yugoslavia, Romania, Bulgaria, Hungary, Czechoslovakia],
    total_countries: 1,
    limit_per_country: all_influence(USSR)
  )
]

RomanianAbdication = [
  I::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Romania],
    amount: all_influence(US)
  ),
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Romania],
    amount: Romania.stability
  )
]

Fidel = [
  I::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Cuba],
    amount: all_influence(US)
  ),
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Cuba],
    amount: Cuba.stability
  )
]

Comecon = [
  Arb::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: lambda {
      Countries.select { |c| c.in?(EasternEurope) && !c.controlled_by?(US) }
    },
    limit_per_country: 1,
    total_influence: 4
  )
]

Nasser = [
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Egypt],
    amount: 2
  ),
  I::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Egypt],
    total_influence: lambda { (Egypt.influence(US) / 2.0).ceil }
  )
]

SouthAfricanUnrest = [
  Either(
    AddInfluence(
      player: USSR,
      influence: USSR,
      countries: [SouthAfrica],
      total_influence: 2
    ),
    [
      AddInfluence(
        player: USSR,
        influence: USSR,
        countries: [SouthAfrica],
        total_influence: 1
      ),
      AddInfluence(
        player: USSR,
        influence: USSR,
        countries: Countries.select { |c| c.neighbor?(SouthAfrica) },
        total_influence: 2
      )
    ]
  )
]

PanamaCanalReturned = [
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Panama],
    amount: 1
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [CostaRica],
    amount: 1
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Venezuela],
    amount: 1
  )
]

MuslimRevolution = [
  AnyTwo(
    [Sudan, Iran, Iraq, Egypt, Libya, SaudiArabia, Syria, Jordan].map do |c|
      RemoveInfluence(
        player: USSR,
        influence: US,
        countries: [c],
        limit_per_country: all_influence(US)
      )
    end
  )
]

PuppetGovernments = [
  # optional
  Arb::AddInfluence(
    player: US,
    influence: US,
    countries: lambda {
      Countries.select { |c| c.influence(US).zero? && c.influence(USSR).zero? }
    },
    limit_per_country: 1,
    total_influence: 3
  )
]

Allende = [
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Chile],
    amount: 2
  )
]

SadatExpelsSoviets = [
  I::RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [Egypt],
    amount: all_influence(USSR)
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Egypt],
    amount: 1
  )
]

OasFounded = [
  Arb::AddInfluence(
    player: US,
    influence: US,
    countries: [CentralAmerica, SouthAmerica],
    total_influence: 2
  )
]

LiberationTheology = [
  Arb::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [CentralAmerica],
    limit_per_country: 2,
    total_influence: 3
  )
]

ColonialRearGuards = [
  Arb::AddInfluence(
    player: US,
    influence: US,
    countries: [Africa, SoutheastAsia],
    limit_per_country: 1,
    total_influence: 4
  )
]

PortugueseEmpireCrumbles = [
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: SeAfricanStates,
    amount: 2,
  ),
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: Angola,
    amount: 2,
  )
]

TheVoiceOfAmerica = [
  Arb::RemoveInfluence(
    player: US,
    influence: USSR,
    countries: Countries.reject { |c| c.in?(Europe) },
    limit_per_country: 2,
    total_influence: 4
  )
]

Solidarity = [
  Requires(JohnPaulIiElectedPope),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Poland],
    amount: 3
  )
]

MarineBarracksBombing = [
  I::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Lebanon],
    amount: all_influence(US)
  ),
  Arb::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [MiddleEast],
    total_influence: 2
  )
]

PershingIiDeployed = [
  AwardVictoryPoints(
    player: USSR,
    amount: 1
  ),
  Arb::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [WesternEurope],
    limit_per_country: 1,
    total_influence: 3
  )
]

TheIronLady = [
  AwardVictoryPoints(
    player: US,
    amount: 1
  ),
  I::AddInfluence(
    player: US,
    influence: USSR,
    countries: [Argentina],
    amount: 1
  ),
  I::RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [UnitedKingdom],
    amount: all_influence(USSR)
  )
]

IranianHostageCrisis = [
  I::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Iran],
    amount: all_influence(US)
  ),
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Iran],
    amount: 2
  )
]

CampDavidAccords = [
  AwardVictoryPoints(
    player: US,
    amount: 1
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Israel],
    amount: 1
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Jordan],
    amount: 1
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Egypt],
    amount: 1
  )
]

JohnPaulIiElectedPope = [
  I::RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [Poland],
    amount: 2
  ),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Poland],
    amount: 1
  )
]

MarshallPlan = [
  Arb::AddInfluence(
    player: US,
    influence: US,
    countries: lambda {
      Countries.select { |c| c.in?(WesternEurope) && !c.controlled_by?(USSR) }
    },
    limit_per_country: 1,
    total_influence: 7
  )
]

WarsawPactFormed = [
  Either(
    AnyFour(
      Countries.select { |c| c.in?(EasternEurope) }.map do |eeuc|
        RemoveInfluence(
          player: USSR,
          influence: US,
          countries: [eeuc],
          limit_per_country: all_influence(US)
        )
      end
    ),
    Arb::AddInfluence(
      player: USSR,
      influence: USSR,
      countries: [EasternEurope],
      limit_per_country: 2,
      total_influence: 5
    )
  )
]

WillyBrandt = [
  PreventedBy(TearDownThisWall),
  AwardVictoryPoints(
    player: USSR,
    amount: 1
  ),
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [WestGermany],
    amount: 1
  )
  # NOTE: The NATO card checks for the West Germany cancellation clause.
]

DeGaulleLeadsFrance = [
  I::RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [France],
    amount: 2
  ),
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [France],
    amount: 1
  )
  # NOTE: The NATO card checks for the France cancellation clause.
]

AnEvilEmpire = [
  Cancels(FlowerPower),
  AwardVictoryPoints(
    player: US,
    amount: 1
  )
]

ReaganBombsLibya = [
  AwardVictoryPoints(
    player: US,
    amount: lambda { |game| game.country(:libya).influence(USSR) / 2 }
  )
]

Opec = [
  PreventedBy(NorthSeaOil),
  AwardVictoryPoints(
    player: USSR,
    amount: lambda do |game|
      [Egypt, Iran, Libya, SaudiArabia, Iraq, GulfStates, Venezuela].map do |c|
        c.controlled_by?(USSR) ? 1 : 0
      end.reduce(:+)
    end
  )
]

AllianceForProgress = [
  AwardVictoryPoints(
    player: US,
    amount: lambda do |game|
      game.countries.
        select { |c| c.in?(CentralAmerica) || c.in?(SouthAmerica) }.
        select { |c| c.battleground? }.
        select { |c| c.controlled_by?(US) }.
        size
    end
  )
]

# Needs a Requires condition because of leading if.
# See NOTES and section 5.2 ex4
KitchenDebates = [
  AwardVictoryPoints(
    player: US,
    amount: lambda do |game|
      battlegrounds = game.countries.select { |c| c.battleground? }

      ussr = battlegrounds.select { |c| c.controlled_by?(USSR) }
      us   = battlegrounds.select { |c| c.controlled_by?(US) }

      us > ussr ? 2 : 0
    end
  )
]

IranIraqWar = [
  War(
    ops: 2,
    player: lambda { player },
    countries: [Iran, Iraq],
    subtract: lambda do |invaded_country|
      invaded_country.neighbors.
        select { |c| c.controlled_by?(player.opponent) }.
        size
    end,
    victory_rolls: 4..6,
    victory_vp: 2
  )
]

BrushWar = [
  War(
    ops: 3,
    player: lambda { player },
    countries: lambda do |game|
      # Remove US-controlled EU countries if Nato is in effect
      countries = game.in_effect?(Nato) ?
        Countries.reject { |c| c.in?(Europe) && c.controlled_by?(US) } :
        Countries.all

      countries.select { |c| [1,2].include?(c.stability) }
    end,
    subtract: lambda do |invaded_country|
      invaded_country.neighbors.
        select { |c| c.controlled_by?(player.opponent) }.
        size
    end,
    victory_rolls: 3..6,
    victory_vp: 1
  )
]

ArabIsraeliWar = [
  PreventedBy(CampDavidAccords),
  War(
    ops: 2,
    player: USSR,
    countries: [Israel],
    subtract: lambda do |invaded_country|
      [invaded_country, *invaded_country.neighbors].
        select { |c| c.controlled_by?(US) }.
        size
    end,
    victory_rolls: 4..6,
    victory_vp: 2
  )
]

IndoPakistaniWar = [
  War(
    player: lambda { player },
    ops: 2,
    countries: [India, Pakistan],
    subtract: lambda do |invaded_country|
      invaded_country.neighbors.
        select { |c| c.controlled_by?(player.opponent) }.
        size
    end,
    victory_rolls: 4..6,
    victory_vp: 2
  )
]

KoreanWar = [
  War(
    player: USSR,
    ops: 2,
    countries: [SouthKorea],
    subtract: lambda do |invaded_country|
      invaded_country.neighbors.
        select { |c| c.controlled_by?(US) }.
        size
    end,
    victory_rolls: 4..6,
    victory_vp: 2
  )
]

OrtegaElectedInNicaragua = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Nicaragua],
    limit_per_country: all_influence(US)
  ),
  Either(
    FreeCoup(
      player: USSR,
      countries: [Nicaragua],
      ops: 2
    ),
    Noop()
  )
]

TearDownThisWall = [
  Cancels(WillyBrandt),
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [EastGermany],
    amount: 3
  ),
  Either(
    FreeCoup(
      player: US,
      countries: [Europe],
      ops: 3
    ),
    Realignment(
      # TODO
    ),
    Noop()
  )
]

Junta = [
  Arb::AddInfluence(
    player: lambda { player },
    influence: lambda { player },
    countries: [CentralAmerica, SouthAmerica],
    limit_per_country: 2,
    total_countries: 1,
    total_influence: 2
  ),
  Either(
    FreeCoup(
      player: lambda { player },
      countries: [CentralAmerica, SouthAmerica],
      ops: 2
    ),
    Realignment(
      # TODO
    ),
    Noop()
  )
]

NuclearTestBan = [
  AwardVictoryPoints(
    player: lambda { player },
    amount: lambda { game.defcon - 2 }
  ),
  ImproveDefcon(amount: 2)
]

DuckAndCover = [
  DegradeDefcon(amount: 1),
  AwardVictoryPoints(
    player: US,
    amount: lambda { 5 - game.defcon }
  )
]

CapturedNaziScientist = [
  AdvanceSpaceRace(amount: 1)
]

OneSmallStep = [
  AdvanceSpaceRace(
    amount: lambda {
      game.space_race(player) < game.space_race(player.opponent) ? 2 : 0
    }
  )
]

HowILearnedToStopWorrying = [
  ExpectMove(
    move: SetDefcon,
    player: lambda { player }
  ),
  AddMilitaryOps(
    player: lambda { player },
    amount: 5
  )
]

ArmsRace = [
  AwardVictoryPoints(
    player: lambda { player },
    amount: lambda {
      more = game.military_ops(player) > game.military_ops(player.opponent)
      met  = game.military_ops(player) >= game.required_military_ops

      if    more && met then 3
      elsif met         then 1
      else  0
      end
    }
  )
]

## Challenges

# Challenges are tasks that must be undertaken by the specified
# player either imediately, or defered . If the task cannot be met, then the failure block executes,
# otherwise the success block is executed.

# If the US fails to discard a >= 3 ops card, then the USSR removes all US
# influence from West Germany.
Blockade = [
  Challenge(
    player: US,
    task: [
      Discard(player: US, ops: [:>=, 3])
    ],
    failure: [
      RemoveInfluence(
        player: USSR,
        influence: US,
        countries: [WestGermany],
        limit_per_country: all_influence(US)
      )
    ]
  )
]

LatinAmericanDebtCrisis = [
  Challenge(
    player: US,
    task: [
      Discard(player: US, ops: [:>=, 3])
    ],
    failure: [
      AnyTwo(
        Countries.select{ |c| c.in?(SouthAmerica) }.map do |c|
          AddInfluence(
            player: USSR,
            influence: USSR,
            countries: [c],
            limit_per_country: all_influence(USSR)
          )
        end
      )
    ]
  )
]

# Challenge the US to play UN Intervention on their next action round.
# Failure to do so results in 3 VP for USSR.
#
# Defcon always degrades by 1.
WeWillBuryYou = [
  Challenge(
    player: US,
    defer: ActionRound(player: US),
    task: [
      CardPlay(
        player: US,
        played_for: :event,
        card: UnIntervention
      )
    ],
    failure: [
      AwardVictoryPoints(player: USSR, amount: 3, immediate: true)
    ]
  ),
  DegradeDefcon(amount: 1)
]

Terrorism = [
  Discard(
    player: lambda { player.opponent },
    random: true,
    quantity: lambda {
      player.ussr? && game.in_effect?(IranianHostageCrisis) ? 2 : 1
    }
  )
]

FiveYearPlan = [
  Discard(
    player: USSR,
    random: true,
    execute_event: lambda { |card| card.side == US }
  )
]

# Event only playable if the required condition is met.
#
# PickFromDiscard should always show the opponent the picked card.
#
StarWars = [
  If(
    lambda { game.space_race(US) > game.space_race(USSR) },
    [
      PickFromDiscard(
        player: US,
        ops: [:>=, 1], # Not a scoring card
        execute_event: true
      ),
      Remove(StarWars)
    ],
    Discard(StarWars)
  )
]

UnIntervention = [
  # Not allowed during headline. Player must have a opponent card in hand.
  Requires(condition: lambda { |game|
    !game.turn.zero? && game.hand(player).any? { |c| c.side == player.opponent }
  }),

  # Discard an opponent card from the current player's hand. Do not execute
  # event. Use ops value for operations.
  Discard(
    player: lambda { player },
    side: lambda { player.opponent },
    execute_event: false,
    execute: [:operations]
  )
]

SaltNegotiations = [
  ImproveDefcon(amount: 2),
  AddModifier(Modifiers::SaltNegotiations),
  PickFromDiscard(
    player: lambda { player },
    ops: [:>=, 1], # Not a scoring card
    execute_event: false
  )
]

Modifiers::SaltNegotiations = [
  DieRollModifier(
    player: nil, # this affects both players!
    type: :coup,
    amount: -1,
    terminate: on_turn_end
  )
]

## Conditionals

CulturalRevolution = [
  If(
    lambda { game.china_card_holder.us? },
    ClaimChinaCard(
      player: USSR,
      playable: true
    ),
    AwardVictoryPoints(
      player: USSR,
      amount: 1
    )
  )
]

NixonPlaysTheChinaCard = [
  If(
    lambda { game.china_card_holder.us? },
    AwardVictoryPoints(
      player: US,
      amount: 2
    ),
    ClaimChinaCard(
      player: US,
      playable: false
    )
  )
]

UssuriRiverSkirmish = [
  If(
    lambda { game.china_card_holder.ussr? },
    ClaimChinaCard(
      player: US,
      playable: true
    ),
    Arb::AddInfluence(
      player: US,
      influence: US,
      countries: [Asia],
      limit_per_country: 2,
      total_influence: 4
    )
  )
]

## Bonus card play

# It should be noted that all offers to play an extra bonus card are optional.

Glasnost = [
  AwardVictoryPoints(player: USSR, amount: 2),
  ImproveDefcon(amount: 1),
  If(
    lambda { game.in_effect?(TheReformer) },
    FreeMove(
      player: USSR,
      type: [:influence, :realignment],
      ops: 4
    )
  )
]

SovietsShootDownKal007 = [
  DegradeDefcon(amount: 1),
  AwardVictoryPoints(player: US, amount: 2),
  If(
    lambda { SouthKorea.controlled_by?(US) },
    FreeMove(
      player: US,
      type: [:influence, :realignment],
      ops: 4
    )
  )
]

LoneGunman = [
  RevealHand(player: US),
  FreeMove(
    player: USSR,
    type: :operations,
    ops: 1
  )
]

AbmTreaty = [
  ImproveDefcon(amount: 1),
  FreeMove(
    player: lambda { player },
    type: :operations,
    ops: 4
  )
]

CiaCreated = [
  RevealHand(player: USSR),
  FreeMove(
    player: US,
    type: :operations,
    ops: 1
  )
]


## Modifiers

FlowerPower = [
  PreventedBy(AnEvilEmpire),
  AddModifier(Modifiers::FlowerPower)
]

WAR_CARDS = [
  ArabIsraeliWar, KoreanWar, BrushWar, IndoPakistaniWar, IranIraqWar
]

# - on us play of any war card (or any war card except arab-israeli if camp
#   david has been played)
# - award the USSR 2 vp.
Modifiers::FlowerPower = [
  Modifier(
    on: CardPlay(
      player: US,
      played_for: [:event, :operations], # operations: (influence,coup,realign)
      card: lambda {
        game.in_effect?(CampDavidAccords) ?
          WAR_CARDS - [ArabIsraeliWar] :
          WAR_CARDS
      }
    ),
    actions: [
      AwardVictoryPoints(player: USSR, amount: 2)
    ]
  )
]

BearTrap = [
  AddModifier(Modifiers::BearTrap)
]

# - fires before each USSR action round
# - cancelled by discarding >= 2 ops AND die roll 1-4
# - if not cancelled, USSR can play a zero-op (scoring) card if they have one.
Modifiers::BearTrap = [
  Modifier(
    before: ActionRound(player: USSR),
    cancel_challenge: [
      Discard(player: USSR, ops: [:>=, 2]),
      DieRoll(player: USSR, value: 1..4)
    ],
    cancel_failure: [
      CardPlay(player: USSR, max_ops: 0), # USSR must satisfy this if they
                                          # have a suitable card
      ActionRoundEnd(player: USSR)
    ]
  )
]

Quagmire = [
  AddModifier(Modifiers::Quagmire)
]

# TODO: Same as bear trap, just swap USSR for US.
Modifiers::Quagmire = Modifiers::BearTrap

CubanMissileCrisis = [
  SetDefcon(amount: 2),
  AddModifier(Modifiers::CubanMissileCrisis)
]

# - A coup anywhere by anyone
# - Triggers a game end for the opponent (they lose)
# - Canceled at any time by USSR removing 2 influence from Cuba, or
#   US removing 2 influence from WG or Turkey
Modifiers::CubanMissileCrisis = [
  Modifier(
    on: Coup(),
    triggers: LoseGame(
      player: lambda { player.opponent }
    ),
    terminate: [ # Check event history on each 'tick' for any of these matches
      Match(
        item: RemoveInfluence,
        player: USSR,
        country: Cuba,
        amount: 2
      ),
      Match(
        item: RemoveInfluence,
        player: US,
        country: WestGermany,
        amount: 2
      ),
      Match(
        item: RemoveInfluence,
        player: US,
        country: Turkey,
        amount: 2
      ),
      on_turn_end
    ]

  )
]

U2Incident = [
  AwardVictoryPoints(player: USSR, amount: 1),
  AddModifier(Modifiers::U2Incident)
]

Modifiers::U2Incident = [
  Modifiers(
    on: Match(item: UnIntervention, type: :event),
    triggers: AwardVictoryPoints(player: USSR, amount: 1),
    terminate: [
      on_turn_end,
      Match(item: UnIntervention, type: :event)
    ]
  )
]

AldrichAmesRemix = [
  AddModifier(Modifiers::AldrichAmesRemix),
  Discard(
    player: USSR,
    hand: US,
    quantity: 1
  )
]

Modifiers::AldrichAmesRemix = [
  Modifier(
    on: Match(), # match anything
    triggers: RevealHand(player: US),
    terminate: on_turn_end
  )
]

# TODO
# Somehow flag this so it is executed whenever the china card is played for
# operation/coup/realign
#
# This list should be executed before the player influences/coups/realigns
#
TheChinaCard = [
  AddModifier(Modifiers::TheChinaCard)
]

Modifiers::TheChinaCard = [
  OpsModifier(
    player: lambda { player },
    countries: [Asia],
    amount: +1,
    terminate: on_action_round_end
  )
]

## Permission Modifiers

# Permission modifiers must be consulted whenever a matching play occurs. If
# the resulting ruling is negative, then the matching play should not go ahead.

Nato = [
  Either(
    Requires(WarsawPactFormed),
    Requires(MarshallPlan)
  ),
  AddModifier(Modifiers::Nato)
]

Modifiers::Nato = [
  PermissionModifier(
    on: Match(item: BrushWar, type: :event),
    ruling: :deny
  ),
  PermissionModifier(
    on: Match(
      player: USSR,
      item: [Coup, Realignment],
      countries: lambda {
        denied = Countries.select { |c| c.controlled_by?(US) && c.in?(Europe) }
        denied.delete(WestGermany) if game.in_effect?(WillyBrandt)
        denied.delete(France)      if game.in_effect?(DeGaulleLeadsFrance)
        denied
      }
    ),
    ruling: :deny
  )
]

UsJapanMutualDefensePact = [
  I::AddInfluence(
    player: US,
    influence: US,
    countries: [Japan],
    amount: Japan.stability
  ),
  AddModifier(Modifiers::UsJapanMutualDefensePact)
]

Modifiers::UsJapanMutualDefensePact = [
  PermissionModifier(
    on: Match(
      player: USSR,
      item: [Coup, Realignment],
      countries: [Japan],
    ),
    ruling: :deny
  )
]

TheReformer = [
  Arb::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Europe],
    limit_per_country: 2,
    total_influence: lambda { |game| game.leader == USSR ? 6 : 4 }
  ),
  AddModifier(Modifiers::TheReformer)
]

Modifiers::TheReformer = [
  PermissionModifier(
    on: Match(item: Coup, player: USSR),
    ruling: :deny
  )
]


## Score Modifiers

Containment = [
  AddModifier(Containment)
]

Modifiers::Containment = [
  OpsModifier(
    player: US,
    amount: +1,
    terminate: on_turn_end
  )
]

BrezhnevDoctrine = [
  AddModifier(Modifiers::BrezhnevDoctrine)
]

Modifiers::BrezhnevDoctrine = [
  OpsModifier(
    player: USSR,
    amount: +1,
    terminate: on_turn_end
  )
]

RedScarePurge = [
  AddModifier(Modifiers::RedScarePurge)
]

Modifiers::RedScarePurge = [
  OpsModifier(
    player: lambda { player },
    amount: -1,
    terminate: on_turn_end
  )
]

LatinAmericanDeathSquads = [
  AddModifier(Modifiers::LatinAmericanDeathSquads)
]

Modifiers::LatinAmericanDeathSquads = [
  DieRollModifier(
    player: lambda { player },
    type: :coup,
    countries: [CentralAmerica, SouthAmerica],
    amount: +1,
    terminate: on_turn_end
  ),
  DieRollModifier(
    player: lambda { player.opponent },
    type: :coup,
    countries: [CentralAmerica, SouthAmerica],
    amount: -1,
    terminate: on_turn_end
  )
]

VietnamRevolts = [
  I::AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Vietnam],
    amount: 2
  ),
  AddModifier(Modifiers::VietnamRevolts)
]

Modifiers::VietnamRevolts = [
  OpsModifier(
    player: USSR,
    countries: [SoutheastAsia],
    amount: +1,
    terminate: on_turn_end
  )
]

IranContraScandal = [
  AddModifier(Modifiers::IranContraScandal)
]

Modifiers::IranContraScandal = [
  DieRollModifier(
    player: US,
    type: :realignment,
    amount: -1,
    terminate: on_turn_end
  )
]

## Scoring Modifiers

# Scoring modifiers change how one or more countries are scored whenever the
# modifier is triggered.

FormosanResolution = [
  AddModifier(Modifiers::FormosanResolution)
]

Modifiers::FormosanResolution = [
  ScoringModifier(
    on: Match(
      item: Score,
      regions: [Asia],
    ),
    countries: lambda { Taiwan.controlled_by?(US) ? [Taiwan] : [] },
    battleground: true,
    terminate: Match(
      player: US,
      item: ChinaCard,
      type: :event
    )
  )
]

NuclearSubs = [
  AddModifier(Modifiers::NuclearSubs)
]

Modifiers::NuclearSubs = [
  PermissionModifier(
    on: Match(
      item: Instructions::DegradeDefcon,
      # TODO also catch free coup? (if it is a different instruction...)
      reason: Match(item: Instructions::Coup, player: US)),
    ruling: :deny,
    terminate: on_turn_end
  )
]

## Scoring Cards

AsiaScoring = [
  Score(
    region: Asia,
    presence: 3,
    domination: 7,
    control: 9,
    battleground: 1,
    superpower: 1
  )
]

EuropeScoring = [
  Score(
    region: Europe,
    presence: 3,
    domination: 7,
    control: :victory,
    battleground: 1,
    superpower: 1
  )
]

MiddleEastScoring = [
  Score(
    region: MiddleEast,
    presence: 3,
    domination: 5,
    control: 7,
    battleground: 1
  )
]

CentralAmericaScoring = [
  Score(
    region: CentralAmerica,
    presence: 1,
    domination: 3,
    control: 5,
    battleground: 1,
    superpower: 1
  )
]

SouthAmericaScoring = [
  Score(
    region: SouthAmerica,
    presence: 2,
    domination: 5,
    control: 6,
    battleground: 1
  )
]

AfricaScoring = [
  Score(
    region: Africa,
    presence: 1,
    domination: 4,
    control: 6,
    battleground: 1
  )
]

SoutheastAsiaScoring = [
  # Award VP for each controlled country
  ScoreCountries(
    countries: [SoutheastAsia],
    amount: lambda { |country| country == Thailand ? 2 : 1 }
  )
]

## Dice Rolls

# Dice rolls expect both players to roll a die.

Summit = [
  RollDies(
    scoring: lambda { |superpower| # addtional points for each superpower roll
      game.regions.select { |r|
        r.controlled_by?(superpower) || r.dominated_by?(superpower)
      }.size
    },
    allow_ties: true,
    winner: [
      AwardVictoryPoints(
        player: lambda { |roll_result| roll_result.winner },
        amount: 2
      ),
      Either(
        DegradeDefcon(
          player: lambda { |result| result.winner },
          amount: 1
        ),
        ImproveDefcon(
          player: lambda { |result| result.winner },
          amount: 1
        )
      )
    ]
  )
]

OlympicGames = [
  Either(
    ExpectMove(
      player: lambda { player.opponent },
      item: SponsorOlympicGames
    ),
    ExpectMove(
      player: lambda { player.opponent },
      item: BoycottOlympicGames
    )
  ),
  If(
    Match(item: SponsorOlympicGames),
    RollDies(
      scoring: lambda { |superpower|
        superpower == game.player ? 2 : 0
      },
      allow_ties: false, # ties are re-rolled
      winner: [
        AwardVictoryPoints(
          player: lambda { |result| result.winner },
          amount: 2
        )
      ]
    ),
    [
      DegradeDefcon(amount: 1),
      FreeMove(
        player: lambda { player },
        type: :operations,
        ops: 4
      )
    ]
  )
]

## Custom Functions

DeStalinization = [
  RelocateInfluence(
    player: USSR,
    influence: USSR,
    destination_countries: lambda {
      Countries.reject { |c| c.controlled_by?(US) }
    },
    limit_per_country: 2,
    total_influence: 4,
    must_use_all_influence: false # player can relocate *up to* 4 influence.
  )
]

AskNotWhatYourCountry = [
  ReplaceCards(player: US)
]

NorthSeaOil = [
  AddModifier(Modifiers::NorthSeaOil)
]

Modifiers::NorthSeaOil = [
  # Give the US player an extra Action Round for just this turn.
  OptionalActionRoundModifier(
    player: US,
    terminate: on_turn_end
  )
]

Defectors = [
  If(
    lambda { |game| game.turn.zero? }, # if headline phase?
    CancelEvent(player: USSR, discard: true), # supercedes other headline plays
    If(
      Match(
        player: USSR,
        item: Defectors,
        type: :event
      ),
      AwardVictoryPoints(player: US, amount: 1)
    )
  )
]

GrainSalesToSoviets = [
  PickAndPlayFromHand(
    player: US,
    hand: USSR,
    random: true,

    # Actions that occur if the player:
    #  - selects the picked card
    #  - rejects the picked card
    #  - has an opponent with an empty hand

    select: [
      ExpectMove(
        item: lambda { |selected_card| selected_card.name },
        player: US,
        type: [:event, :operations, :space]
      ),
      Discard(
        card: lambda { |selected_card| selected_card.name }
      )
    ],
    reject: [
      FreeMove(
        player: US,
        type: [:operations],
        ops: 2
      )
    ],
    empty_hand: [
      FreeMove(
        player: US,
        type: [:operations],
        ops: 2
      )
    ]
  )
]

MissileEnvy = [
  ExchangeCard(
    player: lambda { player },
    execute_event: lambda { |new_card|
      new_card.side == player || new_card.side.nil?
    },
    execute_ops: lambda {
      new_card.side == player.opponent
    }
  ),
  AddModifier(Modifiers::MissileEnvy)
]

Modifiers::MissileEnvy = [
  Modifier(
    on: Match(
      item: ActionRound,
      player: lambda { player.opponent }
    ),
    triggers: ExpectMove(
      item: MissileEnvy,
      player: lambda { player.opponent },
      type: :operations
    )
  )
]

## Cards that take a custom move as actionable input

Wargames = [
  Requires(condition: lambda { |game| game.defcon == 2 }),
  Either(
    ExpectMove(
      move: WargamesInput,
      value: :award_vp_and_end_game,
      player: lambda { player }
    ),
    ExpectMove(
      move: WargamesInput,
      value: :award_vp,
      player: lambda { player }
    ),
    ExpectMove(
      move: WargamesInput,
      value: :nothing,
      player: lambda { player }
    )
  ),
  If(
    Match(
      item: WargamesInput,
      value: :award_vp_and_end_game,
      player: lambda { player }
    ),
    [
      AwardVictoryPoints(
        player: lambda { player.opponent },
        amount: 6
      ),
      EndGame()
    ]
  ),
  If(
    Match(
      item: WargamesInput,
      value: :award_vp,
      player: lambda { player }
    ),
    [
      AwardVictoryPoints(
        player: lambda { player.opponent },
        amount: 6
      )
    ]
  )
]

Chernobyl = [
  Either(
    *[Europe, Asia, MiddleEast, Africa, CentralAmerica, SouthAmerica].map do |r|
      ExpectMove(
        player: US,
        move: ChernobylInput,
        value: r.name.to_sym
      )
    end
  ),
  [Europe, Asia, MiddleEast, Africa, CentralAmerica, SouthAmerica].map do |r|
    If(
      Match(
        player: US,
        item: ChernobylInput,
        value: r.name.to_sym
      ),
      PermissionModifier(
        on: Match(player: USSR, item: OperationalInfluence),
        terminate: on_turn_end,
        ruling: :deny
      )
    )
  end
]

# This card has to sit in "limbo" - does not instantly go to the discard
# pile.
#
# This is addressed in the cardspec with a new param
#   limbo_after_event: true
#
# This will remove the card from the player's hand, but will not add it to
# either the discard or removed-from-play pile.
#
ShuttleDiplomacy = [
  AddModifier(Modifiers::ShuttleDiplomacy),
  Limbo(ShuttleDiplomacy)
]

asian_mideast_battlegrounds = Countries.select do |c|
  c.battleground? && (c.in?(MiddleEast) || c.in?(Asia))
end

Modifiers::ShuttleDiplomacy = [
  Modifier(
    before: Match(
      item: Score,
      regions: [MiddleEast, Asia]
    ),
    triggers: [
      Either(
        # Defer with a lambda because battlegrounds might change depending on
        # the status of Formosan Resolution
        lambda do
          asian_mideast_battlegrounds.map do |c|
            [
              ExpectMove(
                player: US,
                item: ShuttleDiplomacyExcludeCountry,
                value: c.name.to_sym
              ),
              AddModifier(
                ScoringModifier( # No 'on' param means instant activation
                  player: USSR,
                  countries: c,
                  score: 0
                )
              )
            ]
          end
        end
      ),
      # This is how the card gets from limbo back to discard pile...
      TransferCard(
        from: :limbo,
        to:   :discards,
        card: ShuttleDiplomacy
      )
    ],
    terminate: [
      Match(
        item: Score,
        regions: [MiddleEast, Asia]
      ),
      Match( # This card doesn't apply to final scoring.
        item: TurnEnd,
        number: 10
      )
    ]
  )
]


## Events from the Space Race Track

TwoSpaceRacesPerTurn = [
  AddModifier(Modifiers::TwoSpaceRacesPerTurn)
]

Modifiers::TwoSpaceRacesPerTurn = [
  SpaceRaceAttemptModifier(
    player: lambda { player },
    amount: 1,
    terminate: Match(
      item: SpaceRaceAdvancement,
      player: lambda { player.opponent },
      position: 2,
      first_or_second: :second
    )
  )
]


## TODO need to design headline round
OpponentShowHeadlineFirst = [
  AddModifier(Modifiers::OpponentShowHeadlineFirst)
]


DiscardOneHeldCard = [
  AddModifier(Modifiers::DiscardOneHeldCard)
]

Modifiers::DiscardOneHeldCard = [
  DiscardCardModifier(
    player: lambda { player }
  )
]


EightActionRoundsPerTurn = [
  AddModifier(Modifiers::EightActionRoundsPerTurn)
]

# Add a modifier that grants player an extra action round. Terminates
# once opponent reaches the same spot on the space race track.
Modifiers::EightActionRoundsPerTurn = [
  OptionalActionRoundModifier(
    player: lambda { player },
    terminate: Match(
      item: SpaceRaceAdvancement,
      player: lambda { player.opponent },
      position: 8,
      first_or_second: :second
    )
  )
]


