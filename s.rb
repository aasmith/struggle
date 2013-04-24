require "country_data"

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
  # Each expectation within an array can be accepted without regards of order
  # (if order_sensitive == false).
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

    puts "PLAYING: #{action_or_move}"

    if expectation = expectations.expecting?(action_or_move)
      expectation.execute(action_or_move)

      history << action_or_move

      if expectations.satisfied?
        more_expectations = expectations.execute_terminator(history)

        add_expectations more_expectations if more_expectations

        next_expectation
      end


    else
      raise UnacceptableActionOrMove.new(self, action_or_move)
    end
  end

  def next_expectation
    @current_index += 1
  end

  # Returns the current Expectations object.
  def expectations
    all_expectations[@current_index] or fail "Ran out of expectations!"
  end

  class UnacceptableActionOrMove < StandardError
    def initialize(game, action_or_move)
      @game = game
      @action_or_move = action_or_move
    end

    def to_s
      <<-ERR.strip.gsub(/^\s+/,"  ")
      Invalid move or action.
      Move: #{@action_or_move.inspect}
      could not be matched against:
      #{@game.expectations.inspect}
      ERR
    end
  end

end

class Expectations
  attr_accessor :expectations

  # Code to run once all has been satisfied.
  # Advance turn markers, etc?
  attr_accessor :terminator

  # Order sensitive - if true, expectations must be
  # satisfied in the order they are stored. (the default.)
  attr_accessor :order_sensitive

  DefaultTerminator = Class.new { def execute(*); puts self.class.name; end }

  DEFAULT_ARGS = {
    :terminator      => DefaultTerminator.new,
    :order_sensitive => true
  }

  def initialize(expectations, args = DEFAULT_ARGS)
    self.expectations = [*expectations]
    self.terminator = args[:terminator]
    self.order_sensitive = args[:order_sensitive]
  end

  def satisfied?
    expectations.all? &:satisfied?
  end

  # TODO rename - a bool method should not have a required obj return
  def expecting?(action_or_move)
    if order_sensitive
      # if order sensitive, find the first unsatisfied expectation.
      unsatisfied_expectation = expectations.detect { |x| !x.satisfied? }

      if unsatisfied_expectation.valid?(action_or_move)
        unsatisfied_expectation
      else
        nil
      end
    else
      expectations.detect { |x| x.valid?(action_or_move) }
    end
  end

  def execute_terminator(history)
    terminator.execute(history)
  end

  def explain
    expectations.map(&:explain)
  end

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

  def to_s
    "CardPlay TODO"
  end
end

class HeadlineCardPlay < CardPlay

  def initialize(player, card)
    super(player, card, :event)
  end

  def headline?; true; end

  def to_s
    "%s headlines %s" % [player, card]
  end
end

module Moves
  class Move
    def to_s
      "Move TODO"
    end

    def execute
      raise "Not Implemented!"
    end

    def amount; 1; end
  end

  class Influence < Move
    attr_accessor :player, :country, :amount

    def initialize(player, country, amount)
      self.player = player
      self.country = country
      self.amount = amount
    end

    def to_s
      adds_or_subtracts = amount > 0 ? "adds" : "subtracts"

      "%s %s %s influence points to %s" % [
        player, adds_or_subtracts, amount.abs, country
      ]
    end

    def execute
      # TODO place influence etc.
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

module Terminators
  class HeadlineRound
    # Works out how to resolve the headline play that occurred.
    # Returns the next stack of expectations for appending?
    def execute(history)
      # TODO: this seems rusty - structure history by round or something
      # instead of one flat array.
      # get the last two headline plays.
      headlines = history.grep(HeadlineCardPlay).last(2)

      # Starting with the highest score, build up expectations
      validators = headlines.
        sort_by { |h| h.card.score }.
        map     { |h| h.card.validator.new }.
        reverse

      Expectations.new(validators)
    end
  end
end

module Validators
  class Validator
    attr_accessor :moves

    def initialize
      fail "Someone forgot to create an initializer in #{self.class.name}!"
    end

    def satisfied?
      moves.zero?
    end

    def execute(move)
      move.execute
      self.moves -= move.amount
    end

    def valid?(move)
      moves > 0 && move.amount > 0 && move.amount <= moves
    end

  end

  class Comecon < Validator
    attr_accessor :countries

    def initialize
      self.moves = 4
    end

    def valid?(move)
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

  class OpeningUssrInfluence < Validator
    def initialize
      self.moves = 6
    end

    def explain
      "USSR to place 6 influence points within Eastern Europe."
    end

    def valid?(move)
      # ensure 6 moves, and each move is:
      # in eastern europe.

      # TODO just check if poland for now
      super && move.player.ussr? && move.country == :poland
    end
  end

  class OpeningUsInfluence < Validator
    attr_accessor :moves

    def initialize
      self.moves = 7
    end

    def explain
      "US to place 7 influence points within Western Europe."
    end

    def valid?(move)
      # ensure 7 moves, and each move is:
      # in western europe.

      # TODO just check if canada for now
      super && move.player.us? && move.country == :canada
    end
  end

  # TODO: seems like these validators should be able to inherit from
  # Validator - but the "move" they validate is a CardPlay, which has
  # no execute. Smooth this out.
  class UssrHeadline
    attr_accessor :moves

    def initialize
      self.moves = 1
    end

    def valid?(move)
      HeadlineCardPlay === move && move.player.ussr?
    end

    def execute(move)
      self.moves -= 1
    end

    def satisfied?
      moves.zero?
    end

    def explain
      "ussr headline"
    end
  end

  class UsHeadline
    attr_accessor :moves

    def initialize
      self.moves = 1
    end

    def valid? move
      HeadlineCardPlay === move && move.player.us?
    end

    def execute(move)
      self.moves -= 1
    end

    def satisfied?
      moves.zero?
    end

    def explain
      "us headline"
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

  FIELDS = [:name, :ops, :side, :phase, :remove_after_event, :validator]

  attr_accessor *FIELDS

  alias score ops

  def initialize(args)
    unless (FIELDS - args.keys).empty?
      raise ArgumentError, "missing args: #{(FIELDS - args.keys).join(',')}"
    end

    args.each { |key, value| send("#{key}=", value) }
    add_to_registry
  end

  def add_to_registry
    self.class.add(self)
  end

  def to_s
    asterisk = remove_after_event ? "*" : nil

    "%s%s (%s) [%s, %s]" % [name, asterisk, ops, side, phase]
  end
end

# Sample cards
Comecon = Card.new(
  :name => "COMECON",
  :phase => :early,
  :side => :ussr,
  :ops => 3,
  :remove_after_event => true,
  :validator => Validators::Comecon
)

TrumanDoctrine = Card.new(
  :name => "Truman Doctrine",
  :phase => :early,
  :side => :us,
  :ops => 1,
  :remove_after_event => true,
  :validator => Validators::TrumanDoctrine
)

class Superpower
  def opponent; fail NotImplementedError; end
  def ussr?; false; end
  def us?; false; end
  def to_s; self.class.name.upcase; end
end

class Us < Superpower; end
class Ussr < Superpower; end

US   = Us.new
USSR = Ussr.new

class Us < Superpower
  def opponent; USSR; end
  def us?; true; end
end

class Ussr < Superpower
  def opponent; US; end
  def ussr?; true; end
end

class Country
  attr_accessor :influence

  ATTR_NAMES = [:name, :stability, :battleground, :regions, :neighbors]

  Attributes = Struct.new(*ATTR_NAMES)

  def initialize(name)
    @name = name

    influence = { :us => 0, :ussr => 0 }
    influence.default_proc = lambda { |h,k| fail "Unknown player #{k.inspect}" }

    self.influence = influence
  end

  def in?(region)
    regions.include? region
  end

  def neighbor?(country)
    neighbors.include? country
  end

  def influence(player)
    influence[player]
  end

  def incr_influence(player)
    influence[player] += 1
  end

  def presence?(player)
    influence(player) > 0
  end

  def control?(player)
    influence(player) >= stability + influence(opponent)
  end

  def add_influence(player, countries)
    if can_add_influence?(player, countries)
      incr_influence(player)
    end
  end

  def can_add_influence?(player, countries)
    presence?(player) || player_in_neighboring_country?(player, countries)
  end

  def player_in_neighboring_country?(player, countries)
    neighbors.any? do |neighbor|
      countries.detect { |c| c.name == neighbor && c.presence?(player) }
    end
  end

  def fixed_attributes
    row = COUNTRY_DATA.assoc(@name) or raise "No data for #{@name.inspect}"
    Attributes.new(*row)
  end

  # delegate "stability" to fixed_attributes.stability, etc.
  ATTR_NAMES.each do |attr|
    define_method(attr) do
      fixed_attributes.send(attr)
    end
  end

  alias battleground? battleground
end

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
    add_expectations Expectations.new(Validators::OpeningUssrInfluence.new)

    # Once complete, require placement of US influence.
    add_expectations Expectations.new(Validators::OpeningUsInfluence.new)

    # Once complete, start a regular headline round.
    add_expectations Expectations.new(headline,
      :terminator => Terminators::HeadlineRound.new,
      :order_sensitive => false
    )
  end

  def add_expectations(expectations)
    @all_expectations << expectations
  end

  def headline
    [Validators::UssrHeadline.new, Validators::UsHeadline.new]
  end

  def deal_cards
    puts "dealing cards..."
  end

  def status
    puts "game status..."
  end
end
