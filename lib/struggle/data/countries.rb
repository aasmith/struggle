
# Regions
EasternEurope = EE = "Eastern Europe"
WesternEurope = WE = "Western Europe"
Europe = EU = "Europe"
Asia = AS = "Asia"
SoutheastAsia = SE = "Southeast Asia"
Africa = AF = "Africa"
MiddleEast = ME = "Middle East"
CentralAmerica = CA = "Central America"
SouthAmerica = SA = "South America"


# country spec
#   Name, Stability, Battleground, Regions, Neighbors
COUNTRY_DATA = [
  ["Mexico",              2, true,   CA, ["Guatemala"], "US"],
  ["Cuba",                3, true,   CA, ["Nicaragua", "Haiti"], "US"],
  ["Guatemala",           1, false,  CA, ["Mexico", "El Salvador", "Honduras"]],
  ["El Salvador",         1, false,  CA, ["Guatemala", "Honduras"]],
  ["Honduras",            2, false,  CA, ["Guatemala", "El Salvador", "Costa Rica", "Nicaragua"]],
  ["Nicaragua",           1, false,  CA, ["Cuba", "Honduras", "Costa Rica"]],
  ["Haiti",               1, false,  CA, ["Cuba", "Dominican Republic"]],
  ["Dominican Republic",  1, false,  CA, ["Haiti"]],
  ["Costa Rica",          3, false,  CA, ["Panama", "Nicaragua", "Honduras"]],
  ["Panama",              2, true,   CA, ["Costa Rica", "Columbia"]],

  ["Venezuela",           2, true,   SA, ["Columbia", "Brazil"]],
  ["Ecuador",             2, false,  SA, ["Columbia", "Peru"]],
  ["Columbia",            1, false,  SA, ["Venezuela", "Ecuador", "Panama"]],
  ["Peru",                2, false,  SA, ["Ecuador", "Bolivia", "Chile"]],
  ["Brazil",              2, true,   SA, ["Venezuela", "Uruguay"]],
  ["Bolivia",             2, false,  SA, ["Peru", "Paraguay"]],
  ["Chile",               3, true,   SA, ["Peru", "Argentina"]],
  ["Paraguay",            2, false,  SA, ["Bolivia", "Uruguay", "Argentina"]],
  ["Argentina",           2, true,   SA, ["Chile", "Paraguay", "Uruguay"]],
  ["Uruguay",             2, false,  SA, ["Argentina", "Paraguay", "Brazil"]],

  ["Norway",              4, false,  [EU, WE], ["United Kingdom", "Sweden"]],
  ["Denmark",             3, false,  [EU, WE], ["Sweden", "West Germany"]],
  ["Sweden",              4, false,  [EU, WE], ["Norway", "Denmark", "Finland"]],
  ["United Kingdom",      5, false,  [EU, WE], ["Norway", "France", "Canada", "Benelux"]],
  ["Canada",              4, false,  [EU, WE], ["United Kingdom"], "US"],
  ["Benelux",             3, false,  [EU, WE], ["United Kingdom", "West Germany"]],
  ["West Germany",        4, true,   [EU, WE], ["Denmark", "Benelux", "France", "East Germany"]],
  ["France",              3, true,   [EU, WE], ["United Kingdom", "West Germany", "Spain/Portugal", "Algeria", "Italy"]],
  ["Spain/Portugal",      2, false,  [EU, WE], ["France", "Italy", "Morocco"]],
  ["Italy",               2, true,   [EU, WE], ["France", "Austria", "Yugoslavia", "Greece", "Spain/Portugal"]],
  ["Turkey",              2, false,  [EU, WE], ["Romania", "Bulgaria", "Greece", "Syria"]],
  ["Greece",              2, false,  [EU, WE], ["Italy", "Yugoslavia", "Bulgaria", "Turkey"]],

  ["Finland",             4, false,  [EU, WE, EE], ["Sweden"], "USSR"],
  ["Austria",             4, false,  [EU, WE, EE], ["West Germany", "East Germany", "Hungary", "Italy"]],

  ["East Germany",        3, true,   [EU, EE], ["Poland", "Czechoslovakia", "Austria", "West Germany"]],
  ["Poland",              3, true,   [EU, EE], ["Czechoslovakia", "East Germany"], "USSR"],
  ["Czechoslovakia",      3, false,  [EU, EE], ["East Germany", "Poland", "Hungary"]],
  ["Hungary",             3, false,  [EU, EE], ["Austria", "Czechoslovakia", "Romania", "Yugoslavia"]],
  ["Romania",             3, false,  [EU, EE], ["Turkey", "Yugoslavia", "Hungary"], "USSR"],
  ["Yugoslavia",          3, false,  [EU, EE], ["Hungary", "Romania", "Greece", "Italy"]],
  ["Bulgaria",            3, false,  [EU, EE], ["Turkey", "Greece"]],

  ["Morocco",             3, false,  AF, ["Spain/Portugal", "Algeria", "West African States"]],
  ["Algeria",             2, true,   AF, ["France", "Morocco", "Saharan States", "Tunisia"]],
  ["Tunisia",             2, false,  AF, ["Algeria", "Libya"]],
  ["West African States", 2, false,  AF, ["Morocco", "Ivory Coast"]],
  ["Saharan States",      1, false,  AF, ["Algeria", "Nigeria"]],
  ["Sudan",               1, false,  AF, ["Egypt", "Ethiopia"]],
  ["Ivory Coast",         2, false,  AF, ["West African States", "Nigeria"]],
  ["Nigeria",             1, true,   AF, ["Saharan States", "Ivory Coast", "Cameroon"]],
  ["Ethiopia",            1, false,  AF, ["Sudan", "Somalia"]],
  ["Cameroon",            1, false,  AF, ["Nigeria", "Zaire"]],
  ["Zaire",               1, true,   AF, ["Cameroon", "Angola", "Zimbabwe"]],
  ["Kenya",               2, false,  AF, ["Somalia", "SE African States"]],
  ["Somalia",             2, false,  AF, ["Ethiopia", "Kenya"]],
  ["Angola",              1, true,   AF, ["Zaire", "Botswana", "South Africa"]],
  ["Zimbabwe",            1, false,  AF, ["Zaire", "Botswana"]],
  ["SE African States",   1, false,  AF, ["Kenya", "Zimbabwe"]],
  ["Botswana",            2, false,  AF, ["Zimbabwe", "Angola", "South Africa"]],
  ["South Africa",        3, true,   AF, ["Angola", "Botswana"]],

  ["Lebanon",             1, false,  ME, ["Israel", "Jordan", "Syria"]],
  ["Syria",               2, false,  ME, ["Israel", "Lebanon", "Turkey"]],
  ["Israel",              4, true,   ME, ["Egypt", "Jordan", "Syria", "Lebanon"]],
  ["Iraq",                3, true,   ME, ["Iran", "Gulf States", "Saudi Arabia", "Jordan"]],
  ["Iran",                2, true,   ME, ["Afghanistan", "Pakistan", "Iraq"]],
  ["Libya",               2, true,   ME, ["Egypt", "Tunisia"]],
  ["Egypt",               2, true,   ME, ["Israel", "Sudan", "Libya"]],
  ["Jordan",              2, false,  ME, ["Saudi Arabia", "Iraq", "Lebanon", "Israel"]],
  ["Gulf States",         3, false,  ME, ["Iraq", "Saudi Arabia"]],
  ["Saudi Arabia",        3, true,   ME, ["Gulf States", "Iraq", "Jordan"]],

  ["North Korea",         3, true,   AS, ["South Korea"], "USSR"],
  ["Afghanistan",         2, false,  AS, ["Iran", "Pakistan"], "USSR"],
  ["South Korea",         3, true,   AS, ["North Korea", "Japan", "Taiwan"]],
  ["Pakistan",            2, true,   AS, ["India", "Afghanistan", "Iran"]],
  ["Japan",               4, true,   AS, ["Philippines", "Taiwan", "South Korea"], "US"],
  ["India",               3, true,   AS, ["Burma", "Pakistan"]],
  ["Taiwan",              3, false,  AS, ["South Korea", "Japan"]],
  ["Australia",           4, false,  AS, ["Malaysia"]],
  ["Burma",               2, false,  [AS, SE], ["Laos/Cambodia", "India"]],
  ["Laos/Cambodia",       1, false,  [AS, SE], ["Thailand", "Vietnam", "Burma"]],
  ["Thailand",            2, true,   [AS, SE], ["Malaysia", "Vietnam", "Laos/Cambodia"]],
  ["Vietnam",             1, false,  [AS, SE], ["Thailand", "Laos/Cambodia"]],
  ["Philippines",         2, false,  [AS, SE], ["Japan", "Indonesia"]],
  ["Malaysia",            2, false,  [AS, SE], ["Australia", "Indonesia", "Thailand"]],
  ["Indonesia",           1, false,  [AS, SE], ["Philippines", "Malaysia"]],
]

