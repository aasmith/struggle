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

def all_influence(player)
  lambda { |c| c.influence(player) }
end

Decolonization = [
  AddInfluence(
    player: USSR,
    influence: USSR,
    limit_per_country: 1,
    countries: [Africa, SoutheastAsia],
    total_influence: 4)
]

TrumanDoctrine = [
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: lambda { Europe.uncontrolled },
    limit_per_country: all_influence(USSR),
    total_countries: 1
  )
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
  AddInfluence(
    player: US,
    influence: US,
    countries: [Yugoslavia, Romania, Bulgaria, Hungary, Czechoslovakia],
    total_countries: 1,
    limit_per_country: all_influence(USSR)
  )
]

RomanianAbdication = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Romania],
    limit_per_country: all_influence(US)
  ),
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Romania],
    limit_per_country: Romania.stability
  )
]

Fidel = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Cuba],
    limit_per_country: all_influence(US)
  ),
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Cuba],
    limit_per_country: Cuba.stability
  )
]

Comecon = [
  AddInfluence(
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
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Egypt],
    total_influence: 2
  ),
  RemoveInfluence(
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
  AddInfluence(
    player: US,
    influence: US,
    countries: [Panama, CostaRica, Venezuela],
    limit_per_country: 1
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
  AddInfluence(
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
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Chile],
    total_influence: 2
  )
]

SadatExpelsSoviets = [
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [Egypt],
    limit_per_country: all_influence(USSR)
  ),
  AddInfluence(
    player: US,
    influence: US,
    countries: [Egypt],
    total_influence: 1
  )
]

OasFounded = [
  AddInfluence(
    player: US,
    influence: US,
    countries: [CentralAmerica, SouthAmerica],
    total_influence: 2
  )
]

LiberationTheology = [
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [CentralAmerica],
    limit_per_country: 2,
    total_influence: 3
  )
]

ColonialRearGuards = [
  AddInfluence(
    player: US,
    influence: US,
    countries: [Africa, SoutheastAsia],
    limit_per_country: 1,
    total_influence: 4
  )
]

PortugueseEmpireCrumbles = [
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [SeAfricanStates, Angola],
    limit_per_country: 2,
  )
]

TheVoiceOfAmerica = [
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: Countries.reject { |c| c.in?(Europe) },
    limit_per_country: 2,
    total_influence: 4
  )
]

Solidarity = [
  Requires(JohnPaulIiElectedPope),
  AddInfluence(
    player: US,
    influence: US,
    countries: [Poland],
    limit_per_country: 3
  )
]

MarineBarracksBombing = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Lebanon],
    limit_per_country: all_influence(US)
  ),
  RemoveInfluence(
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
  RemoveInfluence(
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
  AddInfluence(
    player: US,
    influence: USSR,
    countries: [Argentina],
    limit_per_country: 1
  ),
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [UnitedKingdom],
    limit_per_country: all_influence(USSR)
  )
]

IranianHostageCrisis = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [Iran],
    limit_per_country: all_influence(US)
  ),
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Iran],
    limit_per_country: 2
  )
]

CampDavidAccords = [
  AwardVictoryPoints(
    player: US,
    amount: 1
  ),
  AddInfluence(
    player: US,
    influence: US,
    countries: [Israel, Jordan, Egypt],
    limit_per_country: 1
  )
]

JohnPaulIiElectedPope = [
  RemoveInfluence(
    player: US,
    influence: USSR,
    countries: [Poland],
    limit_per_country: 2
  ),
  AddInfluence(
    player: US,
    influence: US,
    countries: [Poland],
    limit_per_country: 1
  )
]

MarshallPlan = [
  AddInfluence(
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
    AddInfluence(
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
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [WestGermany],
    limit_per_country: 1
  )
  # NOTE: The NATO card checks for the West Germany cancellation clause.
]

DeGaulleLeadsFrance = [
  RemoveInfluence(
    player: USSR,
    influence: US,
    countries: [France],
    limit_per_country: 2
  ),
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [France],
    limit_per_country: 1
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
  AddInfluence(
    player: US,
    influence: US,
    countries: [EastGermany],
    limit_per_country: 3
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
  AddInfluence(
    player: lambda { player },
    influence: lambda { player },
    countries: [CentralAmerica, SouthAmerica],
    limit_per_country: 2,
    total_countries: 1
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
      AwardVictoryPoints(player: USSR, amount: 3)
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
  Requires(condition: lambda { game.space_race(US) > game.space_race(USSR) }),
  PickFromDiscard(
    player: US,
    ops: [:>=, 1], # Not a scoring card
    execute_event: true
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
  ScoreModifier(
    player: nil, # this affects both players!
    type: :coup,
    amount: -1,
    cancel: TurnEnd
  )
]

## Branches

CulturalRevolution = [
  Branch(
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
  Branch(
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
  Branch(
    lambda { game.china_card_holder.ussr? },
    ClaimChinaCard(
      player: US,
      playable: true
    ),
    AddInfluence(
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
  Branch(
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
  Branch(
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
    type: [:operations],
    ops: 1
  )
]

AbmTreaty = [
  ImproveDefcon(amount: 1),
  FreeMove(
    player: lambda { player },
    type: [:operations],
    ops: 4
  )
]

CiaCreated = [
  RevealHand(player: USSR),
  FreeMove(
    player: US,
    type: [:operations],
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
    triggers: GameEnd(
      player: lambda { player.opponent }
    ),
    cancel: [ # Checks event history on each 'tick' for any of these matches
      Either(
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
        Match(
          item: TurnEnd
        )
      )
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
    cancel: [
      Either(
        Match(item: TurnEnd),
        Match(item: UnIntervention, type: :event)
      )
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
    cancel: Match(item: TurnEnd)
  )
]

TheChinaCard = [
  Either(
    Move(
      player: lambda { player },
      type: [:operations],
      ops: 4
    ),
    Move(
      player: lambda { player },
      type: [:operations],
      countries: [Asia.countries],
      ops: 5
    )
  ),
  AddModifier(Modifiers::TheChinaCard),
  ClaimChinaCard(
    player: lambda { player.opponent },
    playable: false
  )
]

Modifiers::TheChinaCard = [
  Modifier(
    on: Match(
      item: TurnEnd,
      number: 10
    ),
    triggers: AwardVictoryPoints(
      player: lambda { game.china_card_holder },
      amount: 1
    )
  )
]

## Permission Modifiers

# Permission modifiers must be consulted whenver a matching play occurs. If
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
  AddInfluence(
    player: US,
    influence: US,
    countries: [Japan],
    limit_per_country: Japan.stability
  ),
  AddModifier(Modifiers::UsJapanMutualDefensePact)
]

Modifiers::UsJapanMutualDefensePact = [
  PermissionModifier(
    on: Match(
      player: USSR
      item: [Coup, Realignment],
      countries: [Japan],
    ),
    ruling: :deny
  )
]

TheReformer = [
  AddInfluence(
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
  ScoreModifier(
    player: US,
    type: :ops, # anywhere an ops score is evaluated.
    amount: +1,
    max: 4,
    cancel: TurnEnd
  )
]

BrezhnevDoctrine = [
  AddModifier(Modifiers::BrezhnevDoctrine)
]

Modifiers::BrezhnevDoctrine = [
  ScoreModifier(
    player: USSR,
    type: :ops,
    amount: +1,
    max: 4,
    cancel: TurnEnd
  )
]

RedScarePurge = [
  AddModifier(Modifiers::RedScarePurge)
]

Modifiers::RedScarePurge = [
  ScoreModifier(
    player: lambda { player },
    type: :ops,
    amount: -1,
    mininum: 1,
    cancel: TurnEnd
  )
]

LatinAmericanDeathSquads = [
  AddModifier(Modifiers::LatinAmericanDeathSquads)
]

Modifiers::LatinAmericanDeathSquads = [
  ScoreModifier(
    player: lambda { player },
    type: :coup,
    countries: [CentralAmerica, SouthAmerica],
    amount: +1,
    cancel: TurnEnd
  ),
  ScoreModifier(
    player: lambda { player.opponent },
    type: :coup,
    countries: [CentralAmerica, SouthAmerica],
    amount: -1,
    cancel: TurnEnd
  )
]

VietnamRevolts = [
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Vietnam],
    limit_per_country: 2
  ),
  AddModifier(Modifiers::VietnamRevolts)
]

Modifiers::VietnamRevolts = [
  ScoreModifier(
    player: USSR,
    type: :ops,
    countries: [SoutheastAsia],
    amount: +1,
    cancel: TurnEnd
  )
]

IranContraScandal = [
  AddModifier(Modifiers::IranContraScandal)
]

Modifiers::IranContraScandal = [
  ScoreModifier(
    player: US,
    type: :realignment,
    amount: -1,
    cancel: TurnEnd
  )
]

## Scoring Modifiers

# Scoring modifiers change how one or more countries are scored whenver the
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
    cancel: [
      Match(
        player: US,
        item: ChinaCard,
        type: :event
      )
    ]
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
  TurnModifier(
    player: US,
    action_rounds: 8,
    cancel: TurnEnd
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
        cancel: Match(item: TurnEnd),
        ruling: :deny
      )
    )
  end
]

## In Progress

GrainSalesToSoviets = [
  Discard(
    player: USSR,
    random: true
  )
  # TODO needs user input + if branching
]


NuclearSubs = []

Modifiers::NuclearSubs = [
  # Probably needs some new kind of modifier, not sure about this.
  # patch overlays calls to functions to instead return the given value for
  # the duration of the matched function's execution.
  CoupModifier(
    on: Coup(
      player: US,
      countries: Countries.select(&:battleground?)
    ),
    patch: {
      DegradeDefcon: 0
    },
    cancel: Match(item: TurnEnd)
  )
]


ShuttleDiplomacy = []

Modifiers::ShuttleDiplomacy = [
  # TODO: need input to chose excluded country
  ScoreModifier(
    player: USSR,
    countries: lambda { something },
    cancel: Match(
      item: Scoring,
      region: [MiddleEast, Asia]
    ),
    cancel_timing: :after
  )
]


