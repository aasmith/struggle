class Country

  attr_reader :name, :stability, :battleground, :regions, :neighbors
  attr_reader :adjacent_superpower

  def initialize(name, stability, battleground, regions, neighbors,
                 adjacent_superpower = nil)

    @name = name
    @stability = stability
    @battleground = battleground
    @regions = [*regions]
    @neighbors = neighbors
    @adjacent_superpower = case adjacent_superpower
                           when "US"   then US
                           when "USSR" then USSR
                           when nil    then nil
                           else raise "Bad superpower: #{adjacent_superpower}"
                           end

    @influence = { US => 0, USSR => 0 }
  end

  def in?(region)
    regions.include? region
  end

  def neighbor?(country)
    neighbors.include? country.name
  end

  def influence(player)
    @influence.fetch(player)
  end

  def add_influence(player, amount)
    raise NegativeInfluenceError if amount < 0
    raise ArgumentError, "Invalid superpower" unless @influence.key?(player)

    @influence[player] += amount
  end

  def remove_influence(player, amount)
    raise NegativeInfluenceError if amount < 0
    raise ArgumentError, "Invalid superpower" unless @influence.key?(player)

    if @influence[player] - amount < 0
      raise RangeError, "Influence cannot fall below zero"
    end

    @influence[player] -= amount
  end

  # TODO: does this belong here? Maybe add to AddRestrictedInfluence instead
  def price_of_influence(player)
    controlled_by?(player.opponent) ? 2 : 1
  end

  def presence?(player)
    influence(player) > 0
  end

  def controlled_by?(player)
    influence(player) >= stability + influence(player.opponent)
  end

  def controlled?
    controlled_by?(US) || controlled_by?(USSR)
  end

  def uncontrolled?
    !controlled?
  end

  def player_adjacent_to_superpower?(player)
    adjacent_superpower == player
  end

  alias battleground? battleground

  def to_s
    swords = battleground? ? "⚔" : ""
    adjacent = adjacent_superpower && "#{adjacent_superpower.symbol}"

    basic = "%s %s%s (US:%s, USSR:%s)" % [
      name, swords, adjacent, influence(US), influence(USSR)
    ]

    extra = if controlled_by?(US)
              "Controlled by US"
            elsif controlled_by?(USSR)
              "Controlled by USSR"
            end

    [basic, extra].compact.join(" ")
  end

  NegativeInfluenceError = Class.new(ArgumentError)
end
