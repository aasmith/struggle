class Game

  # Things that hold cards
  attr_accessor :deck, :discarded, :removed

  # Current cards in possession
  attr_accessor :us_hand, :ussr_hand

  # A collection of all moves made to date
  attr_accessor :history

  # Variables tracking the current turn
  attr_accessor :turn, :round, :player

  # DEFCON level
  attr_accessor :defcon

  # China card status
  attr_accessor :china_card_playable # Flipped up?
  attr_accessor :china_card_holder   # US or USSR

  # Military Ops: 0-5
  attr_accessor :us_ops, :ussr_ops

  # Expectations. These are arrays of expected (i.e. allowable moves/actions).
  # Each expectation within an array can be accepted without regards of order.
  # All expectations in the leading array must be met first before any in
  # the next array can be allowed.
  #
  # Thus:
  #
  #  [ [e1a, e1b, e1c], [e2a, e2b], [...] ]
  #
  # All of e1* must be completed before any e2* can be accepted, and so on.
  #
  # Once all expectations are completed in one array, the next array of
  # expectations are set by incrementing a pointer @current_index.
  attr_reader :all_expectations

  # Formal definitions
  alias phasing_player       player
  alias action_round         round
  alias china_card_playable? china_card_playable


  # Accepts actions or moves
  def accept(action_or_move)
    # assert that this action satisfies the immediate array of expectations.
    # execute as needed.
    if acceptable?(action_or_move)
      # it was executed already, rename valid? to something better.
      next_expectations_if_satified
    else
      raise UnacceptableActionOrMove.new(self), action_or_move
    end
  end

  def acceptable?(action_or_move)
    expectations.any? { |x| x.valid?(action_or_move) }
  end

  def next_expectations_if_satified
    next_expectation if expectations.all?(&:satisfied?)
  end

  def next_expectation
    @current_index += 1
  end

  def expectations
    all_expectations[@current_index]
  end

  class UnacceptableActionOrMove < StandardError
    def initialize(game)
      @game = game
    end

    def to_s
      "Invalid move or action. Expected one of: #{
        @game.expectations.map { |x| x.explain }}"
    end
  end

end

class Expectation
  attr_accessor :action_class, :player
end

# The representation of playing a card. The resulting moves the player
# may make are not part of a CardPlay.
class CardPlay
  # The player taking the action.
  attr_accessor :player

  # The type of action being made:
  #  (influence, event, space race, coup, realignment)
  attr_accessor :type

  # The card being played.
  attr_accessor :card

  def initialize(player, card, type)
    self.player = player
    self.card = card
    self.type = type
  end


  def headline?; false; end
end

class HeadlineCardPlay < CardPlay

  def initialize(player, card)
    super(player, card, :event)
  end

  def headline?; true; end
end

module Moves
  class Move
  end

  class Influence < Move
    attr_accessor :player, :country, :amount

    def initialize(player, country, amount)
      self.player = player
      self.country = country
      self.amount = amount
    end
  end

  class Event < Move
    def initialize(player, todo)
    end
  end

  class Coup
    def initialize(player, country)
    end
  end

  class Realign
    def initialize(player, country)
    end
  end

  class SpaceRace
    def initialize(player, card)
    end
  end
end

module Validators
  class Comecon
    def valid?(moves)
      # ensure 4 moves
      # ensure each move is:
      # in a unique country
      # in a country in eastern europe
      # in a country that is not us-controlled
    end
  end

  class TrumanDoctrine
    def valid?(moves)
      # ensure 1 move
      # the move should:
      # remove all ussr influence
      # be in a country in europe
      # be in an uncontrolled country
    end
  end

  class OpeningUssrInfluence
    attr_accessor :moves

    def initialize
      self.moves = 6
    end

    def satisfied?
      moves.zero?
    end

    def explain
      "USSR to place 6 influence points within Eastern Europe."
    end

    def valid?(move)
      # ensure 6 moves, and each move is:
      # in eastern europe.

      # TODO just check if poland for now
      if moves > 0 && move.amount > 0 && move.amount <= moves &&
        move.player == :ussr &&
        move.country == :poland

        # TODO: actually place influence!
        self.moves -= move.amount

      else
        false
      end
    end
  end

  class OpeningUsInfluence
    def explain
      "US to place 7 influence points within Western Europe."
    end

    def valid?(moves)
      # ensure 7 moves, and each move is:
      # in western europe.
    end
  end
end

class Card
  class << self
    def all
      @cards || []
    end

    def add(card)
      @cards ||= []
      @cards << card
    end
  end

  def initialize(*todo)
    # do stuff, then add to registry
  end
end

# Sample cards
Comecon = Card.new(
  :phase => :early,
  :side => :ussr,
  :ops => 3,
  :remove_after_event => true,
  :validator => Validators::Comecon
)

TrumanDoctrine = Card.new(
  :phase => :early,
  :side => :usa,
  :ops => 1,
  :remove_after_event => true,
  :validator => Validators::TrumanDoctrine
)

# Real bits of mostly unimportant code
class Game
  def headline?
    turn.zero?
  end

  # Start a new game
  def initialize
    self.deck = []
    self.discarded = []
    self.removed = []

    self.us_hand = []
    self.ussr_hand = []

    self.history = []

    self.turn = 0 # headline
    self.round = 1
    self.player = :ussr

    self.defcon = 5

    self.china_card_playable = true
    self.china_card_holder = :ussr

    self.us_ops = 0
    self.ussr_ops = 0

    @all_expectations = []
    @current_index = 0

    # TODO: place static influence for usa, ussr

    deal_cards

    # Require placement of USSR influence.
    # Once complete, require placement of US influence.
    # Once complete, start a regular headline round.
    add_expectations Validators::OpeningUssrInfluence.new
    add_expectations Validators::OpeningUsInfluence.new
    add_expectations expect_headline
  end

  def add_expectations(*expectations)
    @all_expectations << expectations.flatten
  end

  def expect_headline
    "DERP"
  end

  def deal_cards
    puts "dealing cards..."
  end

  def status
    puts "game status..."
  end
end
