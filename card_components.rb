# Notes
# -----
#
# Because of dependence on a number of variables, some lambdas will need to
# become a first-class object with injection and an execute method.
# Particularly those related to Wars, and VP awards.
#

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

DeStalinization = [
  RelocateInfluence(
    player: USSR,
    influence: USSR,
    destination_countries: lambda {
      Countries.reject { |c| c.controlled_by?(US) }
    },
    limit_per_country: 2,
    total_influence: 4
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
      countries = game.played?(Nato, :event) ?
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
  FreeCoup(
    player: USSR,
    countries: [Nicaragua],
    ops: 2
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
    )
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
    )
  )
]


TheReformer = [
  AddInfluence(
    player: USSR,
    influence: USSR,
    countries: [Europe],
    limit_per_country: 2,
    total_influence: lambda { |game| game.vp < 0 ? 6: 4 }
  ),
  AddModifier(Modifiers::TheReformer) #TODO
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
  ),
  AddModifier(Modifiers::WillyBrandt) #TODO
]


