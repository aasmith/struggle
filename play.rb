require 's'
require 'pp'

g = Game.new

# Helper to find a country for this game.
C = lambda { |name| Country.find(name, g.countries) }

# Tamper with the hands for this fixed play, the same card will appear in
# both hands for 'testing'
g.hand(USSR).add(
  Comecon,
  OlympicGames,
  Blockade,
  VietnamRevolts,
  Nato,
  FiveYearPlan,
  EuropeScoring
)

g.hand(US).add(
  TrumanDoctrine,
  Blockade,
  RedScarePurge,
  Containment,
  Nato,
  EastEuropeanUnrest
)

# Various placements of influence

puts "Expecting USSR influence placement"
p g.expectations.explain

g.accept Moves::UnrestrictedInfluence.new(USSR, C[:poland], +6)

puts "Expecting US influence placement"
p g.expectations.explain

g.accept Moves::UnrestrictedInfluence.new(US, C[:italy], +2)
g.accept Moves::UnrestrictedInfluence.new(US, C[:canada], +2)
g.accept Moves::UnrestrictedInfluence.new(US, C[:west_germany], +3)

# DONE!

puts "Expecting any headline"
p g.expectations.explain

# Headline starts
g.accept Moves::HeadlineCardPlay.new(USSR, Comecon)

puts "Expecting US headline"
p g.expectations.explain

# Awaits a usa headline play
g.accept Moves::HeadlineCardPlay.new(US, TrumanDoctrine)


puts "Expect summary of headline cards played"
g.status # "Headline plays: USSR Comecon, USA Truman Doctrine"


# Players may now execute moves according to ordering (ussr first)

g.accept Moves::UnrestrictedInfluence.new(USSR, C[:poland], +1)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:east_germany], +1)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:yugoslavia], +1)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:czechoslovakia], +1)

# Now usa
g.accept Moves::OpponentInfluence.new(US, C[:yugoslavia], -1)

puts "First round starts..."

g.accept Moves::CardPlay.new(USSR, OlympicGames, :event)

# OR ? g.accept Moves::Event.new(USSR, OlympicGames)

g.status # USSR plays ogames as event - us to participate?

g.accept Moves::OlympicSponsorOrBoycott.new(US, :sponsor)

g.status # some olympics outcome....

# Play opponent card -- use the ops first then ussr gets event.
g.accept Moves::CardPlay.new(US, Blockade, [:influence, :event])

# Pretending blockade has 4 ops for now.
g.accept Moves::Influence.new(US, C[:east_germany], +2)
g.accept Moves::Influence.new(US, C[:france], +1)
g.accept Moves::Influence.new(US, C[:france], +1)

# now the event - one of these...
g.accept Moves::UnrestrictedInfluence.new(US, C[:west_germany], -3)
#g.accept Moves::Discard.new(US, Comecon) # TODO pick a card

# USSR to coup
g.accept Moves::CardPlay.new(USSR, Blockade, :coup)
g.accept Moves::Coup.new(USSR, C[:italy])

# US red scares!
g.accept Moves::CardPlay.new(US, RedScarePurge, :event)

# USSR plays Vietnam revolts
g.accept Moves::CardPlay.new(USSR, VietnamRevolts, :event)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:vietnam], +2)

# something US
g.accept Moves::CardPlay.new(US, Containment, :event)

# USSR using vietnam revolts modifier for this play
mod = g.modifiers.detect { |m| Modifiers::VietnamRevolts === m }
g.accept Moves::CardPlay.new(USSR, Nato, { :event => nil, :influence => mod })

g.accept Moves::Influence.new(USSR, C[:laos], +1)
g.accept Moves::Influence.new(USSR, C[:thailand], +1)
g.accept Moves::Influence.new(USSR, C[:thailand], +1)
g.accept Moves::Influence.new(USSR, C[:vietnam], +1)

# Stupid move, this is a no-op...
g.accept Moves::CardPlay.new(US, Nato, :event)

g.accept Moves::CardPlay.new(USSR, FiveYearPlan, [:event, :influence])

# Picks random card from USSR hand, executes if US card.
# Discards the picked card.
# Ensures event occurs as the player in the argument (for defcon etc).
g.accept Moves::FiveYearPlan.new(USSR)

# Discarded card is Duck and Cover
g.accept Moves::DuckAndCover.new(USSR)

g.accept Moves::Influence.new(USSR, C[:thailand], +1)
g.accept Moves::Influence.new(USSR, C[:thailand], +1)

g.accept Moves::CardPlay.new(US, EastEuropeanUnrest, :event)

g.accept Moves::Influence.new(US, C[:poland], -1)
g.accept Moves::Influence.new(US, C[:czech], -1)
g.accept Moves::Influence.new(US, C[:finland], -1)

g.accept Moves::CardPlay.new(USSR, EuropeScoring, :event)
g.accept Moves::EuropeScoring.new(USSR)

File.write "game.out", Marshal.dump(g)
