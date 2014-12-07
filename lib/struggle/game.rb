class Game
  attr_reader :engine,
              :countries, :deck, :turn, :defcon, :china_card, :space_race,
              :cards, :military_ops, :victory_track, :hands, :phasing_player,
              :current_cards, :discards, :removed, :limbo, :victory, :rng,
              :die, :injector, :guard_resolver, :events, :events_in_effect

  def initialize
    @injector = Injector.new(self)

    @cards = Cards.new
    @countries = Countries.new(COUNTRY_DATA)

    @rng = Random.new
    @die = Die.new(rng)
    @deck = Deck.new
    @turn = TurnMarker.new
    @defcon = Defcon.new
    @victory = Victory.new
    @china_card = ChinaCard.new
    @space_race = SpaceRace.new
    @military_ops = MilitaryOps.new
    @victory_track = VictoryTrack.new
    @phasing_player = PhasingPlayer.new
    @events_in_effect = EventsInEffect.new

    @hands = Hands.new

    # Cards that are currently being played.
    @current_cards = Set.new

    @discards = Set.new
    @removed = Set.new

    # Limbo is for cards that stay on the board but get put into the discard
    # pile once they are cancelled (i.e. Shuttle Diplomacy).
    @limbo = Set.new

    @events = Events::Finder.new(injector)
    @guard_resolver = GuardResolver.new(injector)

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

