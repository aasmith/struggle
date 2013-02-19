superpowers = %w(USA USSR)

regions = { # TODO: might not need a heirarchy here
  EU = "Europe" => [WE = "Western Europe", EE = "Eastern Europe"],
  AS = "Asia"   => [SE = "Southeast Asia"],
  AF = "Africa" => [],
  ME = "Middle East" => [],
  CA = "Central America" => [],
  SA = "South America" => []
}

# TODO: region scoring

# country spec
#   Name, Stability, US Start, USSR Start, Battleground, Regions, Neighbors
countries = [
  ["Mexico",              2, 0, 0, true,   CA, ["USA", "Guatemala"]],
  ["Cuba",                3, 0, 0, true,   CA, ["USA", "Nicaragua", "Haiti"]],
  ["Guatemala",           1, 0, 0, false,  CA, ["Mexico", "El Salvador", "Honduras"]],
  ["El Salvador",         1, 0, 0, false,  CA, ["Guatemala", "Honduras"]],
  ["Honduras",            2, 0, 0, false,  CA, ["Guatemala", "El Salvador", "Costa Rica", "Nicaragua"]],
  ["Nicaragua",           1, 0, 0, false,  CA, ["Cuba", "Honduras", "Costa Rica"]],
  ["Haiti",               1, 0, 0, false,  CA, ["Cuba", "Dominican Republic"]],
  ["Dominican Republic",  1, 0, 0, false,  CA, ["Haiti"]],
  ["Costa Rica",          3, 0, 0, false,  CA, ["Panama", "Nicaragua", "Honduras"]],
  ["Panama",              2, 1, 0, true,   CA, ["Costa Rica", "Columbia"]],

  ["Venezuela",           2, 0, 0, true,   SA, ["Columbia", "Brazil"]],
  ["Ecuador",             2, 0, 0, false,  SA, ["Columbia", "Peru"]],
  ["Columbia",            1, 0, 0, false,  SA, ["Venezuela", "Ecuador", "Panama"]],
  ["Peru",                2, 0, 0, false,  SA, ["Ecuador", "Bolivia", "Chile"]],
  ["Brazil",              2, 0, 0, true,   SA, ["Venezuela", "Uruguay"]],
  ["Bolivia",             2, 0, 0, false,  SA, ["Peru", "Paraguay"]],
  ["Chile",               3, 0, 0, true,   SA, ["Peru", "Argentina"]],
  ["Paraguay",            2, 0, 0, false,  SA, ["Bolivia", "Uruguay", "Argentina"]],
  ["Argentina",           2, 0, 0, true,   SA, ["Chile", "Paraguay", "Uruguay"]],
  ["Uruguay",             2, 0, 0, false,  SA, ["Argentina", "Paraguay", "Brazil"]],

  ["Norway",              4, 0, 0, false,  [EU, WE], ["United Kingdom", "Sweden"]],
  ["Denmark",             3, 0, 0, false,  [EU, WE], ["Sweden", "West Germany"]],
  ["Sweden",              4, 0, 0, false,  [EU, WE], ["Norway", "Denmark", "Finland"]],
  ["United Kingdom",      5, 5, 0, false,  [EU, WE], ["Norway", "France", "Canada", "Benelux"]],
  ["Canada",              4, 2, 0, false,  [EU, WE], ["USA", "United Kingdom"]],
  ["Benelux",             3, 0, 0, false,  [EU, WE], ["United Kingdom", "West Germany"]],
  ["West Germany",        4, 0, 0, true,   [EU, WE], ["Denmark", "Benelux", "France", "East Germany"]],
  ["France",              3, 0, 0, true,   [EU, WE], ["United Kingdom", "West Germany", "Spain/Portugal", "Algeria", "Italy"]],
  ["Spain/Portugal",      2, 0, 0, false,  [EU, WE], ["France", "Italy", "Morocco"]],
  ["Italy",               2, 0, 0, true,   [EU, WE], ["France", "Austria", "Yugoslavia", "Greece", "Spain/Portugal"]],
  ["Turkey",              2, 0, 0, false,  [EU, WE], ["Romania", "Bulgaria", "Greece", "Syria"]],
  ["Greece",              2, 0, 0, false,  [EU, WE], ["Italy", "Yugoslavia", "Bulgaria", "Turkey"]],

  ["Finland",             4, 0, 1, false,  [EU, WE, EE], ["USSR", "Sweden"]],
  ["Austria",             4, 0, 0, false,  [EU, WE, EE], ["West Germany", "East Germany", "Hungary", "Italy"]],

  ["East Germany",        3, 0, 3, true,   [EU, EE], ["Poland", "Czechoslovakia", "Austria", "West Germany"]],
  ["Poland",              3, 0, 0, true,   [EU, EE], ["USSR", "Czechoslovakia", "East Germany"]],
  ["Czechoslovakia",      3, 0, 0, false,  [EU, EE], ["East Germany", "Poland", "Hungary"]],
  ["Hungary",             3, 0, 0, false,  [EU, EE], ["Austria", "Czechoslovakia", "Romania", "Yugoslavia"]],
  ["Romania",             3, 0, 0, false,  [EU, EE], ["USSR", "Turkey", "Yugoslavia", "Hungary"]],
  ["Yugoslavia",          3, 0, 0, false,  [EU, EE], ["Hungary", "Romania", "Greece", "Italy"]],
  ["Bulgaria",            3, 0, 0, false,  [EU, EE], ["Turkey", "Greece"]],

  ["Morocco",             3, 0, 0, false,  AF, ["Spain/Portugal", "Algeria", "West African States"]],
  ["Algeria",             2, 0, 0, true,   AF, ["France", "Morocco", "Saharan States", "Tunisia"]],
  ["Tunisia",             2, 0, 0, false,  AF, ["Algeria", "Libya"]],
  ["West African States", 2, 0, 0, false,  AF, ["Morocco", "Ivory Coast"]],
  ["Saharan States",      1, 0, 0, false,  AF, ["Algeria", "Nigeria"]],
  ["Sudan",               1, 0, 0, false,  AF, ["Egypt", "Ethiopia"]],
  ["Ivory Coast",         2, 0, 0, false,  AF, ["West African States", "Nigeria"]],
  ["Nigeria",             1, 0, 0, true,   AF, ["Saharan States", "Ivory Coast", "Cameroon"]],
  ["Ethiopia",            1, 0, 0, false,  AF, ["Sudan", "Somalia"]],
  ["Cameroon",            1, 0, 0, false,  AF, ["Nigeria", "Zaire"]],
  ["Zaire",               1, 0, 0, true,   AF, ["Cameroon", "Angola", "Zimbabwe"]],
  ["Kenya",               2, 0, 0, false,  AF, ["Somalia", "SE African States"]],
  ["Somalia",             2, 0, 0, false,  AF, ["Ethiopia", "Kenya"]],
  ["Angola",              1, 0, 0, true,   AF, ["Zaire", "Botswana", "South Africa"]],
  ["Zimbabwe",            1, 0, 0, false,  AF, ["Zaire", "Botswana"]],
  ["SE African States",   1, 0, 0, false,  AF, ["Kenya", "Zimbabwe"]],
  ["Botswana",            2, 0, 0, false,  AF, ["Zimbabwe", "Angola", "South Africa"]],
  ["South Africa",        3, 1, 0, true,   AF, ["Angola", "Botswana"]],

  ["Lebanon",             1, 0, 0, false,  ME, ["Israel", "Jordan", "Syria"]],
  ["Syria",               2, 0, 1, false,  ME, ["Israel", "Lebanon", "Turkey"]],
  ["Israel",              4, 1, 0, true,   ME, ["Egypt", "Jordan", "Syria", "Lebanon"]],
  ["Iraq",                3, 0, 1, true,   ME, ["Iran", "Gulf States", "Saudi Arabia", "Jordan"]],
  ["Iran",                2, 1, 0, true,   ME, ["Afghanistan", "Pakistan", "Iraq"]],
  ["Libya",               2, 0, 0, true,   ME, ["Egypt", "Tunisia"]],
  ["Egypt",               2, 0, 0, true,   ME, ["Israel", "Sudan", "Libya"]],
  ["Jordan",              2, 0, 0, false,  ME, ["Saudi Arabia", "Iraq", "Lebanon", "Israel"]],
  ["Gulf States",         3, 0, 0, false,  ME, ["Iraq", "Saudi Arabia"]],
  ["Saudi Arabia",        3, 0, 0, true,   ME, ["Gulf States", "Iraq", "Jordan"]],

  ["North Korea",         3, 0, 3, true,   AS, ["USSR", "South Korea"]],
  ["Afghanistan",         2, 0, 0, false,  AS, ["USSR", "Iran", "Pakistan"]],
  ["South Korea",         3, 1, 0, true,   AS, ["North Korea", "Japan", "Taiwan"]],
  ["Pakistan",            2, 0, 0, true,   AS, ["India", "Afghanistan", "Iran"]],
  ["Japan",               4, 1, 0, true,   AS, ["USA", "Philippines", "Taiwan", "South Korea"]],
  ["India",               3, 0, 0, true,   AS, ["Burma", "Pakistan"]],
  ["Taiwan",              3, 0, 0, false,  AS, ["South Korea", "Japan"]],
  ["Australia",           4, 4, 0, false,  AS, ["Malaysia"]],
  ["Burma",               2, 0, 0, false,  [AS, SE], ["Laos/Cambodia", "India"]],
  ["Laos/Cambodia",       1, 0, 0, false,  [AS, SE], ["Thailand", "Vietnam", "Burma"]],
  ["Thailand",            2, 0, 0, true,   [AS, SE], ["Malaysia", "Vietnam", "Laos/Cambodia"]],
  ["Vietnam",             1, 0, 0, false,  [AS, SE], ["Thailand", "Laos/Cambodia"]],
  ["Philippines",         2, 1, 0, false,  [AS, SE], ["Japan", "Indonesia"]],
  ["Malaysia",            2, 0, 0, false,  [AS, SE], ["Australia", "Indonesia", "Thailand"]],
  ["Indonesia",           1, 0, 0, false,  [AS, SE], ["Philippines", "Malaysia"]],
]


###### Creation

superpowers.each { |name| Superpower.create!(:name => name) }

regions.each do |names|
  names.flatten.each do |name|
    Region.create!(:name => name)
  end
end

countries.each do |name, stability, us, ussr, battleground, regions, neighbors|
  country = Country.find_or_create_by_name(name)

  [*regions].each do |region_name|
    region = Region.find_by_name(region_name)
    region.countries << country
  end

  country.attributes = {
    :stability => stability,
    :usa_start_points => us,
    :ussr_start_points => ussr,
    :battleground => battleground
  }

  neighbors.each do |neighbor|
    if %w(USA USSR).include?(neighbor)
      country.superpower = Superpower.find_by_name(neighbor)
    else
      if n = Country.find_by_name(neighbor)
        country.neighbors << n
      end
    end
  end

  country.save!
end