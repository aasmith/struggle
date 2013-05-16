require "s"

g = Marshal.load(File.read("game.out"))

C = lambda { |name| Country.find(name, g.countries) }

g.accept Moves::UnrestrictedInfluence.new(US, C[:yugoslavia], -1)
