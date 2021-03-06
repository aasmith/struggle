##
# An enumerable database of +Card+s.
#
class Cards
  include Enumerable

  def initialize(cards = generate_cards)
    @cards = cards
  end

  def find_by_ref(ref)
    detect { |card| card.ref == ref } or
      raise "Couldnt find card with reference #{ref.inspect}"
  end

  def each(&block)
    @cards.each(&block)
  end

  def inspect
    "<Card Database>"
  end

  def generate_cards
    [
      Card.new(
        ref: "AsiaScoring",
        id: 1,
        name: "Asia Scoring",
        phase: :early,
        ops: 0,
        side: nil,
      ),
      Card.new(
        ref: "EuropeScoring",
        id: 2,
        name: "Europe Scoring",
        phase: :early,
        ops: 0,
        side: nil,
      ),
      Card.new(
        ref: "MiddleEastScoring",
        id: 3,
        name: "Middle East Scoring",
        phase: :early,
        ops: 0,
        side: nil,
      ),
      Card.new(
        ref: "DuckAndCover",
        id: 4,
        name: "Duck and Cover",
        phase: :early,
        ops: 3,
        side: US,
      ),
      Card.new(
        ref: "FiveYearPlan",
        id: 5,
        name: "Five Year Plan",
        phase: :early,
        ops: 3,
        side: US,
      ),
      Card.new(
        ref: "TheChinaCard",
        id: 6,
        name: "The China Card",
        phase: :early,
        ops: 4,
        side: nil,
      ),
      Card.new(
        ref: "SocialistGovernments",
        id: 7,
        name: "Socialist Governments",
        phase: :early,
        ops: 3,
        side: USSR,
      ),
      Card.new(
        ref: "Fidel",
        id: 8,
        name: "Fidel",
        phase: :early,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "VietnamRevolts",
        id: 9,
        name: "Vietnam Revolts",
        phase: :early,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Blockade",
        id: 10,
        name: "Blockade",
        phase: :early,
        ops: 1,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "KoreanWar",
        id: 11,
        name: "Korean War",
        phase: :early,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "RomanianAbdication",
        id: 12,
        name: "Romanian Abdication",
        phase: :early,
        ops: 1,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "ArabIsraeliWar",
        id: 13,
        name: "Arab-Israeli War",
        phase: :early,
        ops: 2,
        side: USSR,
      ),
      Card.new(
        ref: "Comecon",
        id: 14,
        name: "Comecon",
        phase: :early,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Nasser",
        id: 15,
        name: "Nasser",
        phase: :early,
        ops: 1,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "WarsawPactFormed",
        id: 16,
        name: "Warsaw Pact Formed",
        phase: :early,
        ops: 3,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "DeGaulleLeadsFrance",
        id: 17,
        name: "De Gaulle Leads France",
        phase: :early,
        ops: 3,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "CapturedNaziScientist",
        id: 18,
        name: "Captured Nazi Scientist",
        phase: :early,
        ops: 1,
        side: nil,
        remove_after_event: true,
      ),
      Card.new(
        ref: "TrumanDoctrine",
        id: 19,
        name: "Truman Doctrine",
        phase: :early,
        ops: 1,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "OlympicGames",
        id: 20,
        name: "Olympic Games",
        phase: :early,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "Nato",
        id: 21,
        name: "NATO",
        phase: :early,
        ops: 4,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "IndependentReds",
        id: 22,
        name: "Independent Reds",
        phase: :early,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "MarshallPlan",
        id: 23,
        name: "Marshall Plan",
        phase: :early,
        ops: 4,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "IndoPakistaniWar",
        id: 24,
        name: "Indo-Pakistani War",
        phase: :early,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "Containment",
        id: 25,
        name: "Containment",
        phase: :early,
        ops: 3,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "CiaCreated",
        id: 26,
        name: "CIA Created",
        phase: :early,
        ops: 1,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "UsJapanMutualDefensePact",
        id: 27,
        name: "US/Japan Mutual Defense Pact",
        phase: :early,
        ops: 4,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "SuezCrisis",
        id: 28,
        name: "Suez Crisis",
        phase: :early,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "EastEuropeanUnrest",
        id: 29,
        name: "East European Unrest",
        phase: :early,
        ops: 3,
        side: US,
      ),
      Card.new(
        ref: "Decolonization",
        id: 30,
        name: "Decolonization",
        phase: :early,
        ops: 2,
        side: USSR,
      ),
      Card.new(
        ref: "RedScarePurge",
        id: 31,
        name: "Red Scare/Purge",
        phase: :early,
        ops: 4,
        side: nil,
      ),
      Card.new(
        ref: "UnIntervention",
        id: 32,
        name: "UN Intervention",
        phase: :early,
        ops: 1,
        side: nil
      ),
      Card.new(
        ref: "DeStalinization",
        id: 33,
        name: "De-Stalinization",
        phase: :early,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "NuclearTestBan",
        id: 34,
        name: "Nuclear Test Ban",
        phase: :early,
        ops: 4,
        side: nil,
      ),
      Card.new(
        ref: "FormosanResolution",
        id: 35,
        name: "Formosan Resolution",
        phase: :early,
        ops: 2,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "Defectors",
        id: 103,
        name: "Defectors",
        phase: :early,
        ops: 2,
        side: US,
        always_evaluate_first: true # for headlines only
      ),
      Card.new(
        ref: "BrushWar",
        id: 36,
        name: "Brush War",
        phase: :mid,
        ops: 3,
        side: nil,
      ),
      Card.new(
        ref: "CentralAmericaScoring",
        id: 37,
        name: "Central America Scoring",
        phase: :mid,
        ops: 0,
        side: nil,
      ),
      Card.new(
        ref: "SoutheastAsiaScoring",
        id: 38,
        name: "Southeast Asia Scoring",
        phase: :mid,
        ops: 0,
        side: nil,
        remove_after_event: true,
      ),
      Card.new(
        ref: "ArmsRace",
        id: 39,
        name: "Arms Race",
        phase: :mid,
        ops: 3,
        side: nil,
      ),
      Card.new(
        ref: "CubanMissileCrisis",
        id: 40,
        name: "Cuban Missile Crisis",
        phase: :mid,
        ops: 3,
        side: nil,
        remove_after_event: true,
      ),
      Card.new(
        ref: "NuclearSubs",
        id: 41,
        name: "Nuclear Subs",
        phase: :mid,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Quagmire",
        id: 42,
        name: "Quagmire",
        phase: :mid,
        ops: 3,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "SaltNegotiations",
        id: 43,
        name: "SALT Negotiations",
        phase: :mid,
        ops: 3,
        side: nil,
        remove_after_event: true,
      ),
      Card.new(
        ref: "BearTrap",
        id: 44,
        name: "Bear Trap",
        phase: :mid,
        ops: 3,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "Summit",
        id: 45,
        name: "Summit",
        phase: :mid,
        ops: 1,
        side: nil,
      ),
      Card.new(
        ref: "HowILearnedToStopWorrying",
        id: 46,
        name: "How I Learned to Stop Worrying",
        phase: :mid,
        ops: 2,
        side: nil,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Junta",
        id: 47,
        name: "Junta",
        phase: :mid,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "KitchenDebates",
        id: 48,
        name: "Kitchen Debates",
        phase: :mid,
        ops: 1,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "MissileEnvy",
        id: 49,
        name: "Missile Envy",
        phase: :mid,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "WeWillBuryYou",
        id: 50,
        name: "“We Will Bury You”",
        phase: :mid,
        ops: 4,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "BrezhnevDoctrine",
        id: 51,
        name: "Brezhnev Doctrine",
        phase: :mid,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "PortugueseEmpireCrumbles",
        id: 52,
        name: "Portuguese Empire Crumbles",
        phase: :mid,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "SouthAfricanUnrest",
        id: 53,
        name: "South African Unrest",
        phase: :mid,
        ops: 2,
        side: USSR,
      ),
      Card.new(
        ref: "Allende",
        id: 54,
        name: "Allende",
        phase: :mid,
        ops: 1,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "WillyBrandt",
        id: 55,
        name: "Willy Brandt",
        phase: :mid,
        ops: 2,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "MuslimRevolution",
        id: 56,
        name: "Muslim Revolution",
        phase: :mid,
        ops: 4,
        side: USSR,
      ),
      Card.new(
        ref: "AbmTreaty",
        id: 57,
        name: "ABM Treaty",
        phase: :mid,
        ops: 4,
        side: nil,
      ),
      Card.new(
        ref: "CulturalRevolution",
        id: 58,
        name: "Cultural Revolution",
        phase: :mid,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "FlowerPower",
        id: 59,
        name: "Flower Power",
        phase: :mid,
        ops: 4,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "U2Incident",
        id: 60,
        name: "U2 Incident",
        phase: :mid,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Opec",
        id: 61,
        name: "OPEC",
        phase: :mid,
        ops: 3,
        side: USSR,
      ),
      Card.new(
        ref: "LoneGunman",
        id: 62,
        name: "“Lone Gunman”",
        phase: :mid,
        ops: 1,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "ColonialRearGuards",
        id: 63,
        name: "Colonial Rear Guards",
        phase: :mid,
        ops: 2,
        side: US,
      ),
      Card.new(
        ref: "PanamaCanalReturned",
        id: 64,
        name: "Panama Canal Returned",
        phase: :mid,
        ops: 1,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "CampDavidAccords",
        id: 65,
        name: "Camp David Accords",
        phase: :mid,
        ops: 2,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "PuppetGovernments",
        id: 66,
        name: "Puppet Governments",
        phase: :mid,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "GrainSalesToSoviets",
        id: 67,
        name: "Grain Sales to Soviets",
        phase: :mid,
        ops: 2,
        side: US,
      ),
      Card.new(
        ref: "JohnPaulIiElectedPope",
        id: 68,
        name: "John Paul II Elected Pope",
        phase: :mid,
        ops: 2,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "LatinAmericanDeathSquads",
        id: 69,
        name: "Latin American Death Squads",
        phase: :mid,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "OasFounded",
        id: 70,
        name: "OAS Founded",
        phase: :mid,
        ops: 1,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "NixonPlaysTheChinaCard",
        id: 71,
        name: "Nixon Plays the China Card",
        phase: :mid,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "SadatExpelsSoviets",
        id: 72,
        name: "Sadat Expels Soviets",
        phase: :mid,
        ops: 1,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "ShuttleDiplomacy",
        id: 73,
        name: "Shuttle Diplomacy",
        phase: :mid,
        ops: 3,
        side: US,
        display_after_event: true
      ),
      Card.new(
        ref: "TheVoiceOfAmerica",
        id: 74,
        name: "The Voice of America",
        phase: :mid,
        ops: 2,
        side: US,
      ),
      Card.new(
        ref: "LiberationTheology",
        id: 75,
        name: "Liberation Theology",
        phase: :mid,
        ops: 2,
        side: USSR,
      ),
      Card.new(
        ref: "UssuriRiverSkirmish",
        id: 76,
        name: "Ussuri River Skirmish",
        phase: :mid,
        ops: 3,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "AskNotWhatYourCountry",
        id: 77,
        name: "“Ask Not What Your Country…”",
        phase: :mid,
        ops: 3,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "AllianceForProgress",
        id: 78,
        name: "Alliance for Progress",
        phase: :mid,
        ops: 3,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "AfricaScoring",
        id: 79,
        name: "Africa Scoring",
        phase: :mid,
        ops: 0,
        side: nil,
      ),
      Card.new(
        ref: "OneSmallStep",
        id: 80,
        name: "“One Small Step…”",
        phase: :mid,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "SouthAmericaScoring",
        id: 81,
        name: "South America Scoring",
        phase: :mid,
        ops: 0,
        side: nil,
      ),
      Card.new(
        ref: "IranianHostageCrisis",
        id: 82,
        name: "Iranian Hostage Crisis",
        phase: :late,
        ops: 3,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "TheIronLady",
        id: 83,
        name: "The Iron Lady",
        phase: :late,
        ops: 3,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "ReaganBombsLibya",
        id: 84,
        name: "Reagan Bombs Libya",
        phase: :late,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "StarWars",
        id: 85,
        name: "Star Wars",
        phase: :late,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "NorthSeaOil",
        id: 86,
        name: "North Sea Oil",
        phase: :late,
        ops: 3,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "TheReformer",
        id: 87,
        name: "The Reformer",
        phase: :late,
        ops: 3,
        side: USSR,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "MarineBarracksBombing",
        id: 88,
        name: "Marine Barracks Bombing",
        phase: :late,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "SovietsShootDownKal007",
        id: 89,
        name: "Soviets Shoot Down KAL-007",
        phase: :late,
        ops: 4,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Glasnost",
        id: 90,
        name: "Glasnost",
        phase: :late,
        ops: 4,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "OrtegaElectedInNicaragua",
        id: 91,
        name: "Ortega Elected in Nicaragua",
        phase: :late,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Terrorism",
        id: 92,
        name: "Terrorism",
        phase: :late,
        ops: 2,
        side: nil,
      ),
      Card.new(
        ref: "IranContraScandal",
        id: 93,
        name: "Iran-Contra Scandal",
        phase: :late,
        ops: 2,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Chernobyl",
        id: 94,
        name: "Chernobyl",
        phase: :late,
        ops: 3,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "LatinAmericanDebtCrisis",
        id: 95,
        name: "Latin American Debt Crisis",
        phase: :late,
        ops: 2,
        side: USSR,
      ),
      Card.new(
        ref: "TearDownThisWall",
        id: 96,
        name: "Tear Down this Wall",
        phase: :late,
        ops: 3,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "AnEvilEmpire",
        id: 97,
        name: "“An Evil Empire”",
        phase: :late,
        ops: 3,
        side: US,
        remove_after_event: true,
        display_after_event: true
      ),
      Card.new(
        ref: "AldrichAmesRemix",
        id: 98,
        name: "Aldrich Ames Remix",
        phase: :late,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "PershingIiDeployed",
        id: 99,
        name: "Pershing II Deployed",
        phase: :late,
        ops: 3,
        side: USSR,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Wargames",
        id: 100,
        name: "Wargames",
        phase: :late,
        ops: 4,
        side: nil,
        remove_after_event: true,
      ),
      Card.new(
        ref: "Solidarity",
        id: 101,
        name: "Solidarity",
        phase: :late,
        ops: 2,
        side: US,
        remove_after_event: true,
      ),
      Card.new(
        ref: "IranIraqWar",
        id: 102,
        name: "Iran-Iraq War",
        phase: :late,
        ops: 2,
        side: nil,
        remove_after_event: true,
      )
    ]
  end
end


