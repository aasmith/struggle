require 's'

g = Game.new

# Helper to find a country for this game.
C = lambda { |name| Country.find(name, g.countries) }

# Various placements of influence

puts "Expecting USSR influence placement"
p g.expectations.explain

g.accept Moves::Influence.new(USSR, C[:poland], +6)

puts "Expecting US influence placement"
p g.expectations.explain

g.accept Moves::Influence.new(US, C[:canada], +4)
g.accept Moves::Influence.new(US, C[:west_germany], +3)

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

g.accept Moves::Influence.new(USSR, C[:poland], +1)
g.accept Moves::Influence.new(USSR, C[:east_germany], +1)
g.accept Moves::Influence.new(USSR, C[:yugoslavia], +1)
g.accept Moves::Influence.new(USSR, C[:czechoslovakia], +1)

# Now usa

g.accept Moves::Influence.new(US, C[:yugoslavia], -1)
