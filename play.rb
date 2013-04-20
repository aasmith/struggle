require 's'

g = Game.new

# Various placements of influence

puts "Expecting USSR influence placement"
p g.expectations.explain

g.accept Moves::Influence.new(:ussr, :poland, +6)

puts "Expecting US influence placement"
p g.expectations.explain

g.accept Moves::Influence.new(:us, :canada, +7)

# DONE!

puts "Expecting any headline"
p g.expectations.explain

# Headline starts
g.accept HeadlineCardPlay.new(:ussr, Comecon)

puts "Expecting US headline"
p g.expectations.explain

# Awaits a usa headline play
g.accept HeadlineCardPlay.new(:usa, TrumanDoctrine)


puts "Expect summary of headline cards played"
g.status # "Headline plays: USSR Comecon, USA Truman Doctrine"


# Players may now execute moves according to ordering (ussr first)

g.accept Moves::Influence.new(:ussr, :poland, +1)
g.accept Moves::Influence.new(:ussr, :east_germany, +1)
g.accept Moves::Influence.new(:ussr, :yugoslavia, +1)
g.accept Moves::Influence.new(:ussr, :czechoslovakia, +1)

# Now usa

g.accept Moves::Influence.new(:usa, :yugoslavia, -2)
