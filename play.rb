require 's'

g = Game.new

# Various placements of influence

# Headline starts
g.accept HeadlineCardPlay.new(:ussr, Comecon)

g.status # "Awaiting US headline"

# Awaits a usa headline play
g.accept HeadlineCardPlay.new(:usa, TrumanDoctrine)

g.status # "Headline plays: USSR Comecon, USA Truman Doctrine"


# Players may now execute moves according to ordering (ussr first)

g.accept Moves::Influence.new(:ussr, :poland, +1)
g.accept Moves::Influence.new(:ussr, :east_germany, +1)
g.accept Moves::Influence.new(:ussr, :yugoslavia, +1)
g.accept Moves::Influence.new(:ussr, :czechoslovakia, +1)

# Now usa

g.accept Moves::Influence.new(:usa, :yugoslavia, -2)
