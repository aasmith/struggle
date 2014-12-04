class Game
  attr_accessor :countries, :deck, :turn, :defcon, :china_card, :space_race,
                :cards, :military_ops, :victory_track, :hands, :phasing_player,
                :current_cards, :discards, :removed, :limbo, :victory, :rng,
                :die, :injector, :guard_resolver, :events, :events_in_effect

  def initialize
    self.injector = Injector.new(self)

    self.cards = Cards.new
    self.countries = Countries.new(COUNTRY_DATA)

    self.rng = Random.new
    self.die = Die.new(rng)
    self.deck = Deck.new
    self.turn = TurnMarker.new
    self.defcon = Defcon.new
    self.victory = Victory.new
    self.china_card = ChinaCard.new
    self.space_race = SpaceRace.new
    self.military_ops = MilitaryOps.new
    self.victory_track = VictoryTrack.new
    self.phasing_player = PhasingPlayer.new
    self.events_in_effect = EventsInEffect.new

    self.hands = Hands.new

    # Cards that are currently being played.
    self.current_cards = Set.new

    self.discards = Set.new
    self.removed = Set.new

    # Limbo is for cards that stay on the board but get put into the discard
    # pile once they are cancelled (i.e. Shuttle Diplomacy).
    self.limbo = Set.new

    self.events = Events::Finder.new(injector)
    self.guard_resolver = GuardResolver.new(injector)

    @engine = Engine.new
    @engine.injector = injector
  end

  def start
    @engine.add_work_item Instructions::Game.new
  end

  def accept(move)
    @engine.accept move
  end

  def hint
    @engine.peek
  end

  def hand(player)
    hands.get(player)
  end

  def observers
    @engine.observers
  end
end

