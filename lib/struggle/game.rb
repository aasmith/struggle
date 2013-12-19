require "engine"

require "superpowers"

class Game
  def initialize
    @engine = Engine.new
  end

  def start
    @engine.add_items x
  end
end


__END__
StartingInfluence = NestingInstruction.new(
  AddInfluence.new(USSR, 1, :syria),
  AddInfluence.new(USSR, 1, :iraq),
  AddInfluence.new(USSR, 3, :north_korea),
  AddInfluence.new(USSR, 3, :east_germany),
  AddInfluence.new(USSR, 1, :finland),

  AddInfluence.new(US, 1, :iran),
  AddInfluence.new(US, 1, :israel),
  AddInfluence.new(US, 1, :japan),
  AddInfluence.new(US, 4, :australia),
  AddInfluence.new(US, 1, :philippines),
  AddInfluence.new(US, 1, :south_korea),
  AddInfluence.new(US, 1, :panama),
  AddInfluence.new(US, 1, :south_africa),
  AddInfluence.new(US, 5, :united_kingdom)
)

