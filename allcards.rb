#AsiaScoring = Card.new(
#  :id => 1,
#  :name => "Asia Scoring",
#  :phase => :early,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::AsiaScoring,
#  :modifier => Modifiers::AsiaScoring
#)
#
#EuropeScoring = Card.new(
#  :id => 2,
#  :name => "Europe Scoring",
#  :phase => :early,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::EuropeScoring,
#  :modifier => Modifiers::EuropeScoring
#)
#
#MiddleEastScoring = Card.new(
#  :id => 3,
#  :name => "Middle East Scoring",
#  :phase => :early,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::MiddleEastScoring,
#  :modifier => Modifiers::MiddleEastScoring
#)

DuckAndCover = Card.new(
  :id => 4,
  :name => "Duck and Cover",
  :phase => :early,
  :ops => 3,
  :side => US,
  :remove_after_event => false,
  :validator => Validators::DuckAndCover,
  :modifier => nil
)

FiveYearPlan = Card.new(
  :id => 5,
  :name => "Five Year Plan",
  :phase => :early,
  :ops => 3,
  :side => US,
  :remove_after_event => false,
  :validator => Validators::FiveYearPlan,
  :modifier => nil
)

#TheChinaCard = Card.new(
#  :id => 6,
#  :name => "The China Card",
#  :phase => :early,
#  :ops => 4,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::TheChinaCard,
#  :modifier => Modifiers::TheChinaCard
#)
#
#SocialistGovernments = Card.new(
#  :id => 7,
#  :name => "Socialist Governments",
#  :phase => :early,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::SocialistGovernments,
#  :modifier => Modifiers::SocialistGovernments
#)
#
#Fidel = Card.new(
#  :id => 8,
#  :name => "Fidel",
#  :phase => :early,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::Fidel,
#  :modifier => Modifiers::Fidel
#)

VietnamRevolts = Card.new(
  :id => 9,
  :name => "Vietnam Revolts",
  :phase => :early,
  :ops => 2,
  :side => USSR,
  :remove_after_event => true,
  :validator => Validators::VietnamRevolts,
  :modifier => Modifiers::VietnamRevolts
)

Blockade = Card.new(
  :id => 10,
  :name => "Blockade",
  :phase => :early,
  :ops => 4, # XXX TODO CHANGE THIS BACK TO ONE
  :side => USSR,
  :remove_after_event => true,
  :validator => Validators::Blockade
)

#KoreanWar = Card.new(
#  :id => 11,
#  :name => "Korean War",
#  :phase => :early,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::KoreanWar,
#  :modifier => Modifiers::KoreanWar
#)
#
#RomanianAbdication = Card.new(
#  :id => 12,
#  :name => "Romanian Abdication",
#  :phase => :early,
#  :ops => 1,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::RomanianAbdication,
#  :modifier => Modifiers::RomanianAbdication
#)
#
#ArabIsraeliWar = Card.new(
#  :id => 13,
#  :name => "Arab-Israeli War",
#  :phase => :early,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::ArabIsraeliWar,
#  :modifier => Modifiers::ArabIsraeliWar
#)

Comecon = Card.new(
  :id => 14,
  :name => "Comecon",
  :phase => :early,
  :ops => 3,
  :side => USSR,
  :remove_after_event => true,
  :validator => Validators::Comecon
)

#Nasser = Card.new(
#  :id => 15,
#  :name => "Nasser",
#  :phase => :early,
#  :ops => 1,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::Nasser,
#  :modifier => Modifiers::Nasser
#)
#
#WarsawPactFormed = Card.new(
#  :id => 16,
#  :name => "Warsaw Pact Formed",
#  :phase => :early,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::WarsawPactFormed,
#  :modifier => Modifiers::WarsawPactFormed
#)
#
#DeGaulleLeadsFrance = Card.new(
#  :id => 17,
#  :name => "De Gaulle Leads France",
#  :phase => :early,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::DeGaulleLeadsFrance,
#  :modifier => Modifiers::DeGaulleLeadsFrance
#)
#
#CapturedNaziScientist = Card.new(
#  :id => 18,
#  :name => "Captured Nazi Scientist",
#  :phase => :early,
#  :ops => 1,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::CapturedNaziScientist,
#  :modifier => Modifiers::CapturedNaziScientist
#)

TrumanDoctrine = Card.new(
  :id => 19,
  :name => "Truman Doctrine",
  :phase => :early,
  :ops => 1,
  :side => US,
  :remove_after_event => true,
  :validator => Validators::TrumanDoctrine
)

OlympicGames = Card.new(
  :id => 20,
  :name => "Olympic Games",
  :phase => :early,
  :ops => 2,
  :side => nil,
  :remove_after_event => false,
  :validator => Validators::OlympicGames
)

Nato = NatoCard.new(
  :id => 21,
  :name => "NATO",
  :phase => :early,
  :ops => 4,
  :side => US,
  :remove_after_event => true,
  :validator => nil,
  :modifier => Modifiers::Nato
)

#IndependentReds = Card.new(
#  :id => 22,
#  :name => "Independent Reds",
#  :phase => :early,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::IndependentReds,
#  :modifier => Modifiers::IndependentReds
#)
#
#MarshallPlan = Card.new(
#  :id => 23,
#  :name => "Marshall Plan",
#  :phase => :early,
#  :ops => 4,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::MarshallPlan,
#  :modifier => Modifiers::MarshallPlan
#)
#
#IndoPakistaniWar = Card.new(
#  :id => 24,
#  :name => "Indo-Pakistani War",
#  :phase => :early,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::IndoPakistaniWar,
#  :modifier => Modifiers::IndoPakistaniWar
#)

Containment = Card.new(
  :id => 25,
  :name => "Containment",
  :phase => :early,
  :ops => 3,
  :side => US,
  :remove_after_event => true,
  :validator => nil,
  :modifier => Modifiers::Containment
)

#CiaCreated = Card.new(
#  :id => 26,
#  :name => "CIA Created",
#  :phase => :early,
#  :ops => 1,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::CiaCreated,
#  :modifier => Modifiers::CiaCreated
#)
#
#UsJapanMutualDefensePact = Card.new(
#  :id => 27,
#  :name => "US/Japan Mutual Defense Pact",
#  :phase => :early,
#  :ops => 4,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::UsJapanMutualDefensePact,
#  :modifier => Modifiers::UsJapanMutualDefensePact
#)
#
#SuezCrisis = Card.new(
#  :id => 28,
#  :name => "Suez Crisis",
#  :phase => :early,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::SuezCrisis,
#  :modifier => Modifiers::SuezCrisis
#)

EastEuropeanUnrest = Card.new(
  :id => 29,
  :name => "East European Unrest",
  :phase => :early,
  :ops => 3,
  :side => US,
  :remove_after_event => false,
  :validator => Validators::EastEuropeanUnrest,
  :modifier => nil
)

#Decolonization = Card.new(
#  :id => 30,
#  :name => "Decolonization",
#  :phase => :early,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::Decolonization,
#  :modifier => Modifiers::Decolonization
#)

RedScarePurge = Card.new(
  :id => 31,
  :name => "Red Scare/Purge",
  :phase => :early,
  :ops => 4,
  :side => nil,
  :remove_after_event => false,
  :validator => nil,
  :modifier => Modifiers::RedScarePurge
)

#UnIntervention = Card.new(
#  :id => 32,
#  :name => "UN Intervention",
#  :phase => :early,
#  :ops => 1,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::UnIntervention,
#  :modifier => Modifiers::UnIntervention
#)
#
#DeStalinization = Card.new(
#  :id => 33,
#  :name => "De-Stalinization",
#  :phase => :early,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::DeStalinization,
#  :modifier => Modifiers::DeStalinization
#)
#
#NuclearTestBan = Card.new(
#  :id => 34,
#  :name => "Nuclear Test Ban",
#  :phase => :early,
#  :ops => 4,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::NuclearTestBan,
#  :modifier => Modifiers::NuclearTestBan
#)
#
#FormosanResolution = Card.new(
#  :id => 35,
#  :name => "Formosan Resolution",
#  :phase => :early,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::FormosanResolution,
#  :modifier => Modifiers::FormosanResolution
#)
#
#Defectors = Card.new(
#  :id => 103,
#  :name => "Defectors",
#  :phase => :early,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => false,
#  :validator => Validators::Defectors,
#  :modifier => Modifiers::Defectors
#)
#
#BrushWar = Card.new(
#  :id => 36,
#  :name => "Brush War",
#  :phase => :mid,
#  :ops => 3,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::BrushWar,
#  :modifier => Modifiers::BrushWar
#)
#
#CentralAmericaScoring = Card.new(
#  :id => 37,
#  :name => "Central America Scoring",
#  :phase => :mid,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::CentralAmericaScoring,
#  :modifier => Modifiers::CentralAmericaScoring
#)
#
#SoutheastAsiaScoring = Card.new(
#  :id => 38,
#  :name => "Southeast Asia Scoring",
#  :phase => :mid,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::SoutheastAsiaScoring,
#  :modifier => Modifiers::SoutheastAsiaScoring
#)
#
#ArmsRace = Card.new(
#  :id => 39,
#  :name => "Arms Race",
#  :phase => :mid,
#  :ops => 3,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::ArmsRace,
#  :modifier => Modifiers::ArmsRace
#)
#
#CubanMissileCrisis = Card.new(
#  :id => 40,
#  :name => "Cuban Missile Crisis",
#  :phase => :mid,
#  :ops => 3,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::CubanMissileCrisis,
#  :modifier => Modifiers::CubanMissileCrisis
#)
#
#NuclearSubs = Card.new(
#  :id => 41,
#  :name => "Nuclear Subs",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::NuclearSubs,
#  :modifier => Modifiers::NuclearSubs
#)
#
#Quagmire = Card.new(
#  :id => 42,
#  :name => "Quagmire",
#  :phase => :mid,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::Quagmire,
#  :modifier => Modifiers::Quagmire
#)
#
#SaltNegotiations = Card.new(
#  :id => 43,
#  :name => "SALT Negotiations",
#  :phase => :mid,
#  :ops => 3,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::SaltNegotiations,
#  :modifier => Modifiers::SaltNegotiations
#)
#
#BearTrap = Card.new(
#  :id => 44,
#  :name => "Bear Trap",
#  :phase => :mid,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::BearTrap,
#  :modifier => Modifiers::BearTrap
#)
#
#Summit = Card.new(
#  :id => 45,
#  :name => "Summit",
#  :phase => :mid,
#  :ops => 1,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::Summit,
#  :modifier => Modifiers::Summit
#)
#
#HowILearnedToStopWorrying = Card.new(
#  :id => 46,
#  :name => "How I Learned to Stop Worrying",
#  :phase => :mid,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::HowILearnedToStopWorrying,
#  :modifier => Modifiers::HowILearnedToStopWorrying
#)
#
#Junta = Card.new(
#  :id => 47,
#  :name => "Junta",
#  :phase => :mid,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::Junta,
#  :modifier => Modifiers::Junta
#)
#
#KitchenDebates = Card.new(
#  :id => 48,
#  :name => "Kitchen Debates",
#  :phase => :mid,
#  :ops => 1,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::KitchenDebates,
#  :modifier => Modifiers::KitchenDebates
#)
#
#MissileEnvy = Card.new(
#  :id => 49,
#  :name => "Missile Envy",
#  :phase => :mid,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::MissileEnvy,
#  :modifier => Modifiers::MissileEnvy
#)
#
#WeWillBuryYou = Card.new(
#  :id => 50,
#  :name => "“We Will Bury You”",
#  :phase => :mid,
#  :ops => 4,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::WeWillBuryYou,
#  :modifier => Modifiers::WeWillBuryYou
#)
#
#BrezhnevDoctrine = Card.new(
#  :id => 51,
#  :name => "Brezhnev Doctrine",
#  :phase => :mid,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::BrezhnevDoctrine,
#  :modifier => Modifiers::BrezhnevDoctrine
#)
#
#PortugueseEmpireCrumbles = Card.new(
#  :id => 52,
#  :name => "Portuguese Empire Crumbles",
#  :phase => :mid,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::PortugueseEmpireCrumbles,
#  :modifier => Modifiers::PortugueseEmpireCrumbles
#)
#
#SouthAfricanUnrest = Card.new(
#  :id => 53,
#  :name => "South African Unrest",
#  :phase => :mid,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::SouthAfricanUnrest,
#  :modifier => Modifiers::SouthAfricanUnrest
#)
#
#Allende = Card.new(
#  :id => 54,
#  :name => "Allende",
#  :phase => :mid,
#  :ops => 1,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::Allende,
#  :modifier => Modifiers::Allende
#)
#
#WillyBrandt = Card.new(
#  :id => 55,
#  :name => "Willy Brandt",
#  :phase => :mid,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::WillyBrandt,
#  :modifier => Modifiers::WillyBrandt
#)
#
#MuslimRevolution = Card.new(
#  :id => 56,
#  :name => "Muslim Revolution",
#  :phase => :mid,
#  :ops => 4,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::MuslimRevolution,
#  :modifier => Modifiers::MuslimRevolution
#)
#
#AbmTreaty = Card.new(
#  :id => 57,
#  :name => "ABM Treaty",
#  :phase => :mid,
#  :ops => 4,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::AbmTreaty,
#  :modifier => Modifiers::AbmTreaty
#)
#
#CulturalRevolution = Card.new(
#  :id => 58,
#  :name => "Cultural Revolution",
#  :phase => :mid,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::CulturalRevolution,
#  :modifier => Modifiers::CulturalRevolution
#)
#
#FlowerPower = Card.new(
#  :id => 59,
#  :name => "Flower Power",
#  :phase => :mid,
#  :ops => 4,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::FlowerPower,
#  :modifier => Modifiers::FlowerPower
#)
#
#U2Incident = Card.new(
#  :id => 60,
#  :name => "U2 Incident",
#  :phase => :mid,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::U2Incident,
#  :modifier => Modifiers::U2Incident
#)
#
#Opec = Card.new(
#  :id => 61,
#  :name => "OPEC",
#  :phase => :mid,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::Opec,
#  :modifier => Modifiers::Opec
#)
#
#LoneGunman = Card.new(
#  :id => 62,
#  :name => "“Lone Gunman”",
#  :phase => :mid,
#  :ops => 1,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::LoneGunman,
#  :modifier => Modifiers::LoneGunman
#)
#
#ColonialRearGuards = Card.new(
#  :id => 63,
#  :name => "Colonial Rear Guards",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => false,
#  :validator => Validators::ColonialRearGuards,
#  :modifier => Modifiers::ColonialRearGuards
#)
#
#PanamaCanalReturned = Card.new(
#  :id => 64,
#  :name => "Panama Canal Returned",
#  :phase => :mid,
#  :ops => 1,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::PanamaCanalReturned,
#  :modifier => Modifiers::PanamaCanalReturned
#)
#
#CampDavidAccords = Card.new(
#  :id => 65,
#  :name => "Camp David Accords",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::CampDavidAccords,
#  :modifier => Modifiers::CampDavidAccords
#)
#
#PuppetGovernments = Card.new(
#  :id => 66,
#  :name => "Puppet Governments",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::PuppetGovernments,
#  :modifier => Modifiers::PuppetGovernments
#)
#
#GrainSalesToSoviets = Card.new(
#  :id => 67,
#  :name => "Grain Sales to Soviets",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => false,
#  :validator => Validators::GrainSalesToSoviets,
#  :modifier => Modifiers::GrainSalesToSoviets
#)
#
#JohnPaulIiElectedPope = Card.new(
#  :id => 68,
#  :name => "John Paul II Elected Pope",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::JohnPaulIiElectedPope,
#  :modifier => Modifiers::JohnPaulIiElectedPope
#)
#
#LatinAmericanDeathSquads = Card.new(
#  :id => 69,
#  :name => "Latin American Death Squads",
#  :phase => :mid,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::LatinAmericanDeathSquads,
#  :modifier => Modifiers::LatinAmericanDeathSquads
#)
#
#OasFounded = Card.new(
#  :id => 70,
#  :name => "OAS Founded",
#  :phase => :mid,
#  :ops => 1,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::OasFounded,
#  :modifier => Modifiers::OasFounded
#)
#
#NixonPlaysTheChinaCard = Card.new(
#  :id => 71,
#  :name => "Nixon Plays the China Card",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::NixonPlaysTheChinaCard,
#  :modifier => Modifiers::NixonPlaysTheChinaCard
#)
#
#SadatExpelsSoviets = Card.new(
#  :id => 72,
#  :name => "Sadat Expels Soviets",
#  :phase => :mid,
#  :ops => 1,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::SadatExpelsSoviets,
#  :modifier => Modifiers::SadatExpelsSoviets
#)
#
#ShuttleDiplomacy = Card.new(
#  :id => 73,
#  :name => "Shuttle Diplomacy",
#  :phase => :mid,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => false,
#  :validator => Validators::ShuttleDiplomacy,
#  :modifier => Modifiers::ShuttleDiplomacy
#)
#
#TheVoiceOfAmerica = Card.new(
#  :id => 74,
#  :name => "The Voice of America",
#  :phase => :mid,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => false,
#  :validator => Validators::TheVoiceOfAmerica,
#  :modifier => Modifiers::TheVoiceOfAmerica
#)
#
#LiberationTheology = Card.new(
#  :id => 75,
#  :name => "Liberation Theology",
#  :phase => :mid,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::LiberationTheology,
#  :modifier => Modifiers::LiberationTheology
#)
#
#UssuriRiverSkirmish = Card.new(
#  :id => 76,
#  :name => "Ussuri River Skirmish",
#  :phase => :mid,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::UssuriRiverSkirmish,
#  :modifier => Modifiers::UssuriRiverSkirmish
#)
#
#AskNotWhatYourCountry = Card.new(
#  :id => 77,
#  :name => "“Ask Not What Your Country…”",
#  :phase => :mid,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::AskNotWhatYourCountry,
#  :modifier => Modifiers::AskNotWhatYourCountry
#)
#
#AllianceForProgress = Card.new(
#  :id => 78,
#  :name => "Alliance for Progress",
#  :phase => :mid,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::AllianceForProgress,
#  :modifier => Modifiers::AllianceForProgress
#)
#
#AfricaScoring = Card.new(
#  :id => 79,
#  :name => "Africa Scoring",
#  :phase => :mid,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::AfricaScoring,
#  :modifier => Modifiers::AfricaScoring
#)
#
#OneSmallStep = Card.new(
#  :id => 80,
#  :name => "“One Small Step…”",
#  :phase => :mid,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::OneSmallStep,
#  :modifier => Modifiers::OneSmallStep
#)
#
#SouthAmericaScoring = Card.new(
#  :id => 81,
#  :name => "South America Scoring",
#  :phase => :mid,
#  :ops => 0,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::SouthAmericaScoring,
#  :modifier => Modifiers::SouthAmericaScoring
#)
#
#IranianHostageCrisis = Card.new(
#  :id => 82,
#  :name => "Iranian Hostage Crisis",
#  :phase => :late,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::IranianHostageCrisis,
#  :modifier => Modifiers::IranianHostageCrisis
#)
#
#TheIronLady = Card.new(
#  :id => 83,
#  :name => "The Iron Lady",
#  :phase => :late,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::TheIronLady,
#  :modifier => Modifiers::TheIronLady
#)
#
#ReaganBombsLibya = Card.new(
#  :id => 84,
#  :name => "Reagan Bombs Libya",
#  :phase => :late,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::ReaganBombsLibya,
#  :modifier => Modifiers::ReaganBombsLibya
#)
#
#StarWars = Card.new(
#  :id => 85,
#  :name => "Star Wars",
#  :phase => :late,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::StarWars,
#  :modifier => Modifiers::StarWars
#)
#
#NorthSeaOil = Card.new(
#  :id => 86,
#  :name => "North Sea Oil",
#  :phase => :late,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::NorthSeaOil,
#  :modifier => Modifiers::NorthSeaOil
#)
#
#TheReformer = Card.new(
#  :id => 87,
#  :name => "The Reformer",
#  :phase => :late,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::TheReformer,
#  :modifier => Modifiers::TheReformer
#)
#
#MarineBarracksBombing = Card.new(
#  :id => 88,
#  :name => "Marine Barracks Bombing",
#  :phase => :late,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::MarineBarracksBombing,
#  :modifier => Modifiers::MarineBarracksBombing
#)
#
#SovietsShootDownKal007 = Card.new(
#  :id => 89,
#  :name => "Soviets Shoot Down KAL-007",
#  :phase => :late,
#  :ops => 4,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::SovietsShootDownKal007,
#  :modifier => Modifiers::SovietsShootDownKal007
#)
#
#Glasnost = Card.new(
#  :id => 90,
#  :name => "Glasnost",
#  :phase => :late,
#  :ops => 4,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::Glasnost,
#  :modifier => Modifiers::Glasnost
#)
#
#OrtegaElectedInNicaragua = Card.new(
#  :id => 91,
#  :name => "Ortega Elected in Nicaragua",
#  :phase => :late,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::OrtegaElectedInNicaragua,
#  :modifier => Modifiers::OrtegaElectedInNicaragua
#)
#
#Terrorism = Card.new(
#  :id => 92,
#  :name => "Terrorism",
#  :phase => :late,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => false,
#  :validator => Validators::Terrorism,
#  :modifier => Modifiers::Terrorism
#)
#
#IranContraScandal = Card.new(
#  :id => 93,
#  :name => "Iran-Contra Scandal",
#  :phase => :late,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::IranContraScandal,
#  :modifier => Modifiers::IranContraScandal
#)
#
#Chernobyl = Card.new(
#  :id => 94,
#  :name => "Chernobyl",
#  :phase => :late,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::Chernobyl,
#  :modifier => Modifiers::Chernobyl
#)
#
#LatinAmericanDebtCrisis = Card.new(
#  :id => 95,
#  :name => "Latin American Debt Crisis",
#  :phase => :late,
#  :ops => 2,
#  :side => USSR,
#  :remove_after_event => false,
#  :validator => Validators::LatinAmericanDebtCrisis,
#  :modifier => Modifiers::LatinAmericanDebtCrisis
#)
#
#TearDownThisWall = Card.new(
#  :id => 96,
#  :name => "Tear Down this Wall",
#  :phase => :late,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::TearDownThisWall,
#  :modifier => Modifiers::TearDownThisWall
#)
#
#AnEvilEmpire = Card.new(
#  :id => 97,
#  :name => "“An Evil Empire”",
#  :phase => :late,
#  :ops => 3,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::AnEvilEmpire,
#  :modifier => Modifiers::AnEvilEmpire
#)
#
#AldrichAmesRemix = Card.new(
#  :id => 98,
#  :name => "Aldrich Ames Remix",
#  :phase => :late,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::AldrichAmesRemix,
#  :modifier => Modifiers::AldrichAmesRemix
#)
#
#PershingIiDeployed = Card.new(
#  :id => 99,
#  :name => "Pershing II Deployed",
#  :phase => :late,
#  :ops => 3,
#  :side => USSR,
#  :remove_after_event => true,
#  :validator => Validators::PershingIiDeployed,
#  :modifier => Modifiers::PershingIiDeployed
#)
#
#Wargames = Card.new(
#  :id => 100,
#  :name => "Wargames",
#  :phase => :late,
#  :ops => 4,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::Wargames,
#  :modifier => Modifiers::Wargames
#)
#
#Solidarity = Card.new(
#  :id => 101,
#  :name => "Solidarity",
#  :phase => :late,
#  :ops => 2,
#  :side => US,
#  :remove_after_event => true,
#  :validator => Validators::Solidarity,
#  :modifier => Modifiers::Solidarity
#)
#
#IranIraqWar = Card.new(
#  :id => 102,
#  :name => "Iran-Iraq War",
#  :phase => :late,
#  :ops => 2,
#  :side => nil,
#  :remove_after_event => true,
#  :validator => Validators::IranIraqWar,
#  :modifier => Modifiers::IranIraqWar
#)
