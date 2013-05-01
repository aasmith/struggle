require 's'

g = Game.new

# Helper to find a country for this game.
C = lambda { |name| Country.find(name, g.countries) }

# Various placements of influence

puts "Expecting USSR influence placement"
p g.expectations.explain

g.accept Moves::UnrestrictedInfluence.new(USSR, C[:poland], +6)

puts "Expecting US influence placement"
p g.expectations.explain

g.accept Moves::UnrestrictedInfluence.new(US, C[:canada], +4)
g.accept Moves::UnrestrictedInfluence.new(US, C[:west_germany], +3)

# DONE!

puts "Expecting any headline"
p g.expectations.explain

# Headline starts
g.accept HeadlineCardPlay.new(USSR, Comecon)

puts "Expecting US headline"
p g.expectations.explain

# Awaits a usa headline play
g.accept HeadlineCardPlay.new(US, TrumanDoctrine)


puts "Expect summary of headline cards played"
g.status # "Headline plays: USSR Comecon, USA Truman Doctrine"


# Players may now execute moves according to ordering (ussr first)

g.accept Moves::UnrestrictedInfluence.new(USSR, C[:poland], +1)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:east_germany], +1)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:yugoslavia], +1)
g.accept Moves::UnrestrictedInfluence.new(USSR, C[:czechoslovakia], +1)

# Now usa

g.accept Moves::UnrestrictedInfluence.new(US, C[:yugoslavia], -1)

puts "First round starts..."

g.accept CardPlay.new(USSR, OlympicGames, :event)

# OR ? g.accept Moves::Event.new(USSR, OlympicGames)

g.status # USSR plays ogames as event - us to participate?

g.accept Moves::OlympicSponsorOrBoycott.new(US, :sponsor)

g.status # some olympics outcome....

# TODO playing for points - but playing ops first
g.accept CardPlay.new(US, Blockade, :event, :ops_before)

# play for ops
g.accept Moves::Operation.new(US, Blockade, :influence)

# Pretending blockade has 4 ops for now.
g.accept Moves::Influence.new(US, C[:east_germany], +2)
g.accept Moves::Influence.new(US, C[:france], +1)
g.accept Moves::Influence.new(US, C[:france], +1)

# now the event - one of these...
g.accept Moves::UnrestrictedInfluence.new(US, C[:west_germany], -3)
g.accept Moves::Discard.new(US, Comecon) # TODO pick a card


