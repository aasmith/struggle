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

  # Countries and their associated presence
  attr_accessor :countries

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

    # Guesses what possible bits of context that the object may need in order
    # to go about its business. This should probably be less guess and more
    # object stating what it needs, and we provide it here.
    #
    # Suggested: add "def self.needs; [:countries]; end" to the object
    # receiving the injections.
    if action_or_move.respond_to?(:countries=)
      action_or_move.countries = countries
    end

    if expectation = expectations.expecting?(action_or_move)
      possible_expectations = expectation.execute(action_or_move)

      add_immediate_expectations *possible_expectations

      history << action_or_move

      expectations.execute_interval(history) if expectation.satisfied?

      if expectations.satisfied?
        more_expectations = expectations.execute_terminator(history)

        add_expectations more_expectations if more_expectations

        next_expectation
      end


    else
      raise UnacceptableActionOrMove.new(expectations, action_or_move)
    end
  end

  def next_expectation
    @current_index += 1
  end

  # Returns the current Expectations object.
  def expectations
    all_expectations[@current_index] or fail "Ran out of expectations!"
  end

  # Add the provided validators (TODO or should these be a new set of nested
  # expectations?) into the current set of expectations, right after the
  # current validation.
  def add_immediate_expectations(*validators)
    if validators.all? { |v| Validators::Validator === v }
      expectations.insert(*validators)
    else
      warn "Not all validators were valid! Got #{validators.inspect}"
    end
  end
end

class UnacceptableActionOrMove < StandardError
  def initialize(expectations, action_or_move)
    @expectations = expectations
    @action_or_move = action_or_move
  end

  def to_s
    <<-ERR.strip.gsub(/^\s+/,"  ")
    Invalid move or action.
    Move: #{@action_or_move.inspect}
    could not be matched against:
    #{@expectations.inspect}
    ERR
  end
end

class Expectations
  attr_accessor :expectations

  # Code to run once all has been satisfied.
  # Advance turn markers, etc?
  attr_accessor :terminator

  # Code to run after each satisfaction, switch phasing player etc?
  attr_accessor :interval

  # Order sensitive - if true, expectations must be
  # satisfied in the order they are stored. (the default.)
  attr_accessor :order_sensitive

  DefaultTerminator = Class.new { def execute(*); puts self.class.name; end }
  DefaultInterval   = Class.new { def execute(*); puts self.class.name; end }

  DEFAULT_ARGS = {
    :terminator      => DefaultTerminator.new,
    :interval        => DefaultInterval.new,
    :order_sensitive => true
  }

  def initialize(expectations, args = {})
    self.expectations = [*expectations]

    args = DEFAULT_ARGS.merge(args)

    self.interval = args[:interval]
    self.terminator = args[:terminator]
    self.order_sensitive = args[:order_sensitive]
  end

  def satisfied?
    expectations.all? &:satisfied?
  end

  # TODO rename - a bool method should not have a required obj return
  def expecting?(action_or_move)
    if order_sensitive?
      # if order sensitive, find the first unsatisfied expectation.
      unsatisfied_expectation = expectations.detect { |x| !x.satisfied? }

      if unsatisfied_expectation.valid?(action_or_move)
        unsatisfied_expectation
      else
        raise UnacceptableActionOrMove.new(
          unsatisfied_expectation, action_or_move)
      end
    else
      expectations.detect { |x| !x.satisfied? && x.valid?(action_or_move) }
    end
  end

  def execute_interval(history)
    interval.execute(history)
  end

  def execute_terminator(history)
    terminator.execute(history)
  end

  def explain
    expectations.map(&:explain)
  end

  # Inserts a validator after the last satisfied validator, or put it on the
  # end if all are satisfied.
  def insert(*validators)
    index = expectations.index { |v| !v.satisfied? } || expectations.size

    expectations.insert(index, *validators)
  end

  alias order_sensitive? order_sensitive
end

class Superpower
  def opponent; fail NotImplementedError; end
  def ussr?; false; end
  def us?; false; end
  def to_s; self.class.name.upcase; end
  alias name to_s
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

# TODO: explain this better
# TODO: why is this not a Move?
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

  # The order of playing ops. This is required when a player has played an
  # opponent's card, thus meaning the event must be played. The player must
  # decide when ops points are played in relation to the event. Valid values
  # in this case are :ops_before or :ops_after.
  #
  # This is affected by a case ruling, see Ruling #2.
  #
  # Otherwise leave nil.
  attr_accessor :order_of_play

  def initialize(player, card, type, order_of_play = nil)
    self.player = player
    self.card = card
    self.type = type
    self.order_of_play = order_of_play

    if player.opponent == card.side
      if invalid_order_of_play?
        raise "order of play was invalid: #{order_of_play.inspect}"
      end
    end

  end

  def headline?; false; end

  # puts the card just played onto the expectation stack. Just like how
  # HeadlineCardRound does it after a couple of HeadlineCardPlays. BUT INSTEAD
  # IT DOES IT RIGHT NOW
  #
  # Returns one or more validators to be placed on the current set of
  # expectations.
  def execute
    if order_of_play == :ops_before
      [Validators::Operation.new(player, card), card.validator.new]
    elsif order_of_play == :ops_after
      [card.validator.new, Validators::Operation.new(player, card)]
    else
      card.validator.new
    end
  end

  def to_s
    "%s plays %s for %s" % [player, card, type]
  end

  def invalid_order_of_play?
    order_of_play.nil? || ![:ops_before, :ops_after].include?(order_of_play)
  end
end

# Deferred kind of CardPlay. They encapsulate the playing of a headline card
# but will not be revealed or acted upon until the HeadlineEnd terminator
# displays them.
class HeadlineCardPlay < CardPlay

  def initialize(player, card)
    super(player, card, :event)
  end

  def headline?; true; end

  def execute; end

  def to_s
    "%s headlines %s" % [player, card]
  end
end

module Moves
  class Move
    def to_s
      "Move TODO in #{self.class.name}"
    end

    def execute
      raise "Not Implemented!"
    end

    def amount; 1; end
  end

  class UnrestrictedInfluence < Move
    attr_accessor :player, :country, :amount

    def initialize(player, country, amount)
      self.player = player
      self.country = country
      self.amount = amount
    end

    def to_s
      adds_or_subtracts = amount > 0 ? "adds" : "subtracts"

      "%s %s %s influence points in %s" % [
        player, adds_or_subtracts, amount.abs, country
      ]
    end

    def execute
      country.add_influence!(player, amount)
    end
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

      "%s %s %s influence points in %s" % [
        player, adds_or_subtracts, amount.abs, country
      ]
    end

    def execute
      country.add_influence!(player, 1)
    end

    # Ignoring all other factors except occupiers of the country, this method
    # returns true if the move has enough influence points for the player to
    # place influence in the target country. This is not always a pertinent
    # question to ask -- such as placing influence during most events.
    def affordable?
      amount == country.price_of_influence(player)
    end

    # Can the player place influence using this restricted list of countries?
    def can_add_influence?(countries_whitelist)
      country.can_add_influence?(player, countries_whitelist)
    end
  end

  class Event < Move
    def initialize(player, todo)
    end

    def execute
      # ...
    end
  end

  class Coup
    def initialize(player, country)
    end
  end

  class Realignment
    def initialize(player, country)
    end
  end

  class SpaceRace
    def initialize(player, card)
    end
  end

  class Operation < Move
    attr_accessor :player, :card, :type, :countries

    # The countries arg allows the validator to take a snapshot of the current
    # state of all countries. This is used to prevent influence creep.
    def initialize(player, card, type)
      self.player = player
      self.card = card
      self.type = validate_type(type)
    end

    def validate_type(type)
      # Valid types for an Operation -- Section 6.0
      types = [:influence, :realignment, :coup, :space_race]

      if types.include?(type)
        return type
      else
        raise "Bad type: #{type.inspect}"
      end
    end

    # Return the requisite number of expectations for the operation.
    def execute
      # TODO: the card points may not be an indicator of how many moves
      # can be made by the player (Red Scare in effect for example).
      instantiate_validator(type_to_validator(type), card.score)
    end

    def type_to_validator(type)
      class_name = type.to_s.split("_").map(&:capitalize).join

      Validators.const_get(class_name, false)
    end

    def instantiate_validator(validator_class, number_of_moves)
      # Doing a case on Class classes is not fun.
      case
      when validator_class == Validators::Influence
        validator_class.new(player, countries, number_of_moves)
      else
        raise "Don't know how to instantiate #{validator_class.inspect}!"
      end
    end

    def to_s
      "%s to play %s for %s" % [player, card, type]
    end
  end

  ### Misc, specialized moves

  class OlympicSponsorOrBoycott < Move
    attr_accessor :player, :sponsor_or_boycott

    def initialize(player, sponsor_or_boycott)
      unless [:sponsor, :boycott].include?(sponsor_or_boycott)
        raise "sponsor_or_boycott must be one of :sponsor or :boycott"
      end

      self.player = player
      self.sponsor_or_boycott = sponsor_or_boycott
    end

    def execute
      # TODO: all of this
      if boycott?
        todo "degrade_defcon"
        todo "play_as_ops"
      else # sponsors
        todo "roll_dice"
        todo "award_vp"
      end
    end

    def boycott?
      sponsor_or_boycott == :boycott
    end

    def to_s
      "The %s decides to %s the Olympic Games." % [player, sponsor_or_boycott]
    end
  end
end

module Terminators
  # A class that shows and queues up the headline events that have been placed
  # by each player.
  class HeadlineCardRound
    # Works out how to resolve the headline play that occurred.
    # Returns the next stack of expectations for appending?
    def execute(history)
      # TODO: this seems rusty - structure history by round or something
      # instead of one flat array.
      # get the last two headline plays.
      headlines = history.grep(HeadlineCardPlay).last(2)

      # TODO: if a tie on card score, US goes first (Rule 4.5 Subsection C)
      # Starting with the highest score, build up expectations
      validators = headlines.
        sort_by { |h| h.card.score }.
        map     { |h| h.card.validator.new }.
        reverse

      puts "HEADLINE CARDS PLAYED!"

      # TODO: maybe update game status here about cards played

      Expectations.new(validators, :terminator => HeadlineEventsEnd.new)
    end
  end

  # A class for processing the end of events being played in the headline
  # round.
  class HeadlineEventsEnd
    def execute(history)
      puts "HEADLINE PHASE ENDED!"

      validators = [
        Validators::CardPlay.new(USSR),
        Validators::CardPlay.new(US)
      ]

      Expectations.new(
        validators,
        :terminator => Terminators::ActionRoundEnd.new
      )
    end
  end

  # Handles the end of each action round. There are multiple action rounds
  # per turn.
  class ActionRoundEnd
    def execute(move)
      puts "ACTION ROUND ENDED!"
    end
  end

  # Handles the end of each turn. There are multiple turns per phase.
  class TurnEnd
    def execute(history)
      puts "TURN ENDED!"
    end
  end
end

module Validators
  class Validator
    def satisfied?
      fail "#{self.class.name} did not impl"
    end

    def execute(move)
      retval = move.execute
      executed(move)
      retval
    end

    def executed(move)
    end

    def valid?(move)
      fail "#{self.class.name} did not impl"
    end
  end

  # Validation that is only satisfied when all remaining influence has been
  # used up. For validating the typical "player places N influence" case.
  #
  # Set remaining_influence in your constructor.
  module TypeAgnosticInfluenceHelper
    attr_accessor :remaining_influence

    def initialize
      fail "Set self.remaining_influence in #{self.class.name}!"
    end

    def valid?(move)
      move.amount > 0 &&
        remaining_influence > 0 &&
        move.amount <= remaining_influence
    end

    def executed(move)
      self.remaining_influence -= move.amount
    end

    def satisfied?
      remaining_influence.zero?
    end
  end

  module InfluenceHelper
    include TypeAgnosticInfluenceHelper

    def valid?(move)
      super && Moves::Influence === move
    end
  end

  module UnrestrictedInfluenceHelper
    include TypeAgnosticInfluenceHelper

    def valid?(move)
      super && Moves::UnrestrictedInfluence === move
    end
  end

  # A module that sets the Validator to a satisfied state once it has been
  # executed exactly once.
  module SingleExecutionHelper
    attr_accessor :satisfied

    def initialize
      self.satisfied = false
    end

    def executed(move)
      self.satisfied = true
    end

    def satisfied?
      satisfied
    end

    def valid?(move)
      fail "not impl in #{self.class.name}"
    end
  end

  # Allows four USSR moves, ensuring each move is:
  #  in a unique country
  #  in a country in Eastern Europe
  #  in a country that is not US-controlled
  class Comecon < Validator

    # Countries that have been used in prior moves.
    attr_accessor :countries

    include UnrestrictedInfluenceHelper

    def initialize
      self.remaining_influence = 4
      self.countries = []
    end

    def valid?(move)
      super &&
        move.amount == 1 &&
        move.country.in?(EasternEurope) &&
        !move.country.controlled_by?(US) &&
        !countries.include?(move.country)
    end

    def executed(move)
      super
      countries << move.country
    end

  end

  # Allows US to remove all USSR influence in an uncontrolled country in
  # Europe once.
  #
  # Precedents:
  #
  # Must be uncontrolled by *both* players, see Ruling #1.
  class TrumanDoctrine < Validator

    include SingleExecutionHelper

    def valid?(move)
      Moves::UnrestrictedInfluence === move &&
        move.player.us? &&
        move.country.in?(Europe) &&
        move.country.uncontrolled? &&
        move.amount + move.country.influence(USSR) == 0
    end
  end

  # Card Text
  # ---------
  #
  # This player sponsors the Olympics. The opponent must either participate
  # or boycott. If the opponent participates, each player rolls a die and
  # the sponsor adds 2 to their roll. The player with the highest modified
  # die roll receives 2 VP (reroll ties). If the opponent boycotts, degrade
  # the DEFCON level by 1 and the sponsor may conduct Operations as if they
  # played a 4 Ops card.
  #
  #
  class OlympicGames < Validator

    include SingleExecutionHelper

    def initialize
      self.satisfied = false
    end

    def valid?(move)
      # accept a boycott or sponsor decision from the opponent
      #
      # TODO: need to access the opponent
      Moves::OlympicSponsorOrBoycott === move
    end
  end

  # Card Text
  # ---------
  #
  # Unless the US immediately discards a card with an Operations value of 3
  # or more, remove all US Influence from West Germany.
  #
  class Blockade < Validator

    # Move is valid if any of:
    #  - discards a card >= 3 ops
    #  - requests to remove *all* influence from west germany
    def valid?(move)
      false
    end

    def satisfied?
      false
    end
  end

  # Allows six USSR placements of influence within Eastern Europe.
  class OpeningUssrInfluence < Validator

    include UnrestrictedInfluenceHelper

    def initialize
      self.remaining_influence = 6
    end

    def explain
      "USSR to place 6 influence points within Eastern Europe."
    end

    def valid?(move)
      super && move.player.ussr? && move.country.in?(EasternEurope)
    end
  end

  # Allows seven US placements of influence within Western Europe.
  class OpeningUsInfluence < Validator

    include UnrestrictedInfluenceHelper

    def initialize
      self.remaining_influence = 7
    end

    def explain
      "US to place 7 influence points within Western Europe."
    end

    def valid?(move)
      super && move.player.us? && move.country.in?(WesternEurope)
    end
  end

  class Headline < Validator
    attr_accessor :expected_player

    include SingleExecutionHelper

    def initialize(expected_player)
      super()
      self.expected_player = expected_player
    end

    def valid?(move)
      # TODO: ensure china card cannot be played (Rule 4.5 Subsection C)
      HeadlineCardPlay === move && move.player == expected_player
    end

    def explain
      "#{expected_player} headline"
    end
  end

  # TODO: Having two classes named CardPlay is bad -- fix
  class CardPlay < Validator
    attr_accessor :expected_player

    include SingleExecutionHelper

    def initialize(expected_player)
      super()
      self.expected_player = expected_player
    end

    def valid?(move)
      ::CardPlay === move && move.player == expected_player
    end
  end

  class Operation < Validator
    attr_accessor :expected_player, :expected_card

    include SingleExecutionHelper

    def initialize(expected_player, expected_card)
      super()

      self.expected_player = expected_player
      self.expected_card = expected_card
    end

    def valid?(move)
      move.player == expected_player &&
        move.card == expected_card &&
        can_play?(move.card, move.type)
    end

    # TODO: delegate this somewhere useful
    # determines if a given card can be played for the type of operation
    # i.e. can the card be space raced etc?
    def can_play?(card, operation_type)
      # SRSLY TODO
      todo "check specific action can be played"
      true
    end
  end

  # An Influence validator that applies the rules of placing influence during
  # operations. For instance, it will test for neighboring occupation, as well
  # as ensuring 2:1 cost of entry during opponent control.
  class Influence < Validator
    attr_accessor :expected_player, :countries, :countries_whitelist

    include InfluenceHelper

    def initialize(expected_player, countries, number_of_moves)
      self.expected_player = expected_player
      self.countries = countries
      self.remaining_influence = number_of_moves

      self.countries_whitelist =
        Country.accessible(expected_player, countries).
        map { |name| Country.find(name, countries) }
    end

    def valid?(move)
      super &&
        Moves::Influence === move &&
        expected_player == move.player &&
        move.affordable? &&
        move.can_add_influence?(countries_whitelist)
    end

    # XXX: Super-lol hack to hide a huge array from inspect
    def inspect
      hide = countries
      self.countries = ["TRUNCATED"]
      r = super
      self.countries = hide
      r
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

    "%s%s (%s) [%s, %s]" % [name, asterisk, ops, side || "neutral", phase]
  end
end

# Sample cards
Comecon = Card.new(
  :name => "COMECON",
  :phase => :early,
  :side => USSR,
  :ops => 3,
  :remove_after_event => true,
  :validator => Validators::Comecon
)

TrumanDoctrine = Card.new(
  :name => "Truman Doctrine",
  :phase => :early,
  :side => US,
  :ops => 1,
  :remove_after_event => true,
  :validator => Validators::TrumanDoctrine
)

OlympicGames = Card.new(
  :name => "Olympic Games",
  :phase => :early,
  :side => nil,
  :ops => 2,
  :remove_after_event => true,
  :validator => Validators::OlympicGames
)

Blockade = Card.new(
  :name => "Blockade",
  :phase => :early,
  :side => USSR,
  :ops => 4, # TODO: this should be 1, but testing something
  :remove_after_event => true,
  :validator => Validators::Blockade
)



class Country
  attr_reader :name, :stability, :battleground, :regions, :neighbors
  attr_reader :influence, :adjacent_superpower


  def initialize(name, stability, battleground, regions, neighbors,
                 adjacent_superpower = nil)

    @name = name
    @stability = stability
    @battleground = battleground
    @regions = regions
    @neighbors = neighbors
    @adjacent_superpower = adjacent_superpower

    influence = { US => 0, USSR => 0 }
    influence.default_proc = lambda { |h,k| fail "Unknown player #{k.inspect}" }

    @influence = influence
  end

  def in?(region)
    regions.include? region
  end

  def neighbor?(country)
    neighbors.include? country.name
  end

  def influence(player)
    @influence[player]
  end

  def add_influence!(player, amount = 1)
    @influence[player] += amount
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

  # TODO: this method should go away now Validators::Influence exists.
  # def add_influence(player, countries, amount = 1)
  #   amount.times do
  #     if can_add_influence?(player, countries)
  #       add_influence!(player)
  #     end
  #   end
  # end

  # Checks if the given player can add influence to this country by checking
  # for presence in or around the country.
  #
  # This country must also be in the list of countries in order to consider
  # itself a valid target for influence.
  def can_add_influence?(player, countries)
    if countries.include?(self)
      presence?(player) || player_in_neighboring_country?(player, countries)
    else
      player_adjacent_to_superpower?(player)
    end
  end

  def player_adjacent_to_superpower?(player)
    adjacent_superpower == player.name
  end

  def player_in_neighboring_country?(player, countries)
    neighbors.any? do |neighbor|
      countries.detect do |c|
        c.name == neighbor && c.presence?(player)
      end
    end
  end

  def price_of_influence(player)
    controlled_by?(player.opponent) ? 2 : 1
  end

  alias battleground? battleground

  def to_s
    basic = "%s (US:%s, USSR:%s)" % [name, influence(US), influence(USSR)]

    extra = if controlled_by?(US)
      "Controlled by US"
    elsif controlled_by?(USSR)
      "Controlled by USSR"
    end

    [basic, extra].join(" ")
  end

  class << self
    def initialize_all
      COUNTRY_DATA.map do |row|
        Country.new(*row)
      end
    end

    # Looks through the given array of countries for an unambiguous
    # match on country name. Name can be a String or Symbol.
    #
    # Not finding a country with the given name is considered an error.
    def find(name, countries)
      name = name.to_s.gsub(/_/, " ")

      results = countries.select do |country|
        country.name =~ /^#{name}/i
      end

      if results.size == 1
        return results.first
      else
        raise AmbiguousName, "No country found for #{name.inspect}"
      end
    end

    # Returns a list of country names that the given player can "access" for
    # the purpose of placing influence, given the current countries and their
    # state of play.
    def accessible(player, countries)
      accessible_countries = []

      countries.each do |country|
        if country.presence?(player)
          accessible_countries.push country.name
          accessible_countries.push *country.neighbors
        end
      end

      accessible_countries.uniq
    end
  end

  AmbiguousName = Class.new(RuntimeError)
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
    self.player = USSR

    self.defcon = 5

    self.china_card_playable = true
    self.china_card_holder = USSR

    self.us_ops = 0
    self.ussr_ops = 0

    self.countries = Country.initialize_all

    @starting_influence_placed = false
    @all_expectations = []
    @current_index = 0

    place_starting_influence

    deal_cards

    # Require placement of USSR influence.
    add_expectations Expectations.new(Validators::OpeningUssrInfluence.new)

    # Once complete, require placement of US influence.
    add_expectations Expectations.new(Validators::OpeningUsInfluence.new)

    # Once complete, start a regular headline round.
    add_expectations Expectations.new(headline,
      :terminator => Terminators::HeadlineCardRound.new,
      :order_sensitive => false
    )
  end

  def add_expectations(expectations)
    @all_expectations << expectations
  end

  def headline
    [Validators::Headline.new(USSR), Validators::Headline.new(US)]
  end

  def deal_cards
    puts "dealing cards..."
  end

  def status
    puts "game status..."
  end

  def place_starting_influence
    fail "Called more than once!" if @starting_influence_placed

    Country.find(:syria, countries).add_influence!(USSR, 1)
    Country.find(:iraq, countries).add_influence!(USSR, 1)
    Country.find(:north_korea, countries).add_influence!(USSR, 3)
    Country.find(:east_germany, countries).add_influence!(USSR, 3)
    Country.find(:finland, countries).add_influence!(USSR, 1)

    Country.find(:iran, countries).add_influence!(US, 1)
    Country.find(:israel, countries).add_influence!(US, 1)
    Country.find(:japan, countries).add_influence!(US, 1)
    Country.find(:australia, countries).add_influence!(US, 4)
    Country.find(:philippines, countries).add_influence!(US, 1)
    Country.find(:south_korea, countries).add_influence!(US, 1)
    Country.find(:panama, countries).add_influence!(US, 1)
    Country.find(:south_africa, countries).add_influence!(US, 1)
    Country.find(:united_kingdom, countries).add_influence!(US, 5)

    @starting_influence_placed = true
  end
end

def todo(thing)
  puts "TODO: #{thing}"
  puts caller if ENV["TODO"]
end
