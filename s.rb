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

  # A victory track for victory points.
  attr_accessor :victory_track

  # The die to be used for generating numbers.
  attr_accessor :die

  # Modifiers that change certain underlying aspects of the gameplay for a
  # limited amount of time.
  attr_accessor :modifiers

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

    inject_variables action_or_move

    expectation = expectations.expecting?(action_or_move) or
      raise UnacceptableActionOrMove.new(expectations, action_or_move)

    results = [*expectation.execute(action_or_move)]

    modifiers.each { |m| inject_variables m }

    results.push *modifiers.executed(action_or_move)

    new_validators = results.grep(Validators::Validator)
    new_modifiers  = results.grep(Modifiers::Modifier)

    add_immediate_expectations new_validators
    add_modifiers new_modifiers

    history.add action_or_move

    # TODO possibly remove intervals
    # expectations.execute_interval(history) if expectation.satisfied?

    if expectations.satisfied?
      terminator = expectations.terminator

      inject_variables terminator

      more_expectations = terminator.execute

      modifiers.executed(terminator)

      add_expectations more_expectations if more_expectations

      history.add terminator

      next_expectation
    end
  end

  # Guesses what possible bits of context that the object may need in order
  # to go about its business. This should probably be less guess and more
  # object stating what it needs, and we provide it here.
  #
  # Suggested: add "def self.needs; [:countries]; end" to the object
  # receiving the injections.
  def inject_variables(target)
    injections = %w(countries defcon current_card current_card die
                    score_resolver history)

    injections.each do |name|
      if target.respond_to?(:"#{name}=")
        target.send(:"#{name}=", send(name.to_sym))
      end
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
  def add_immediate_expectations(validators)
    expectations.insert(*validators)
  end

  def add_modifiers(modifiers)
    self.modifiers.insert *modifiers
  end

  def current_card
    history.current_card
  end

  def current_turn
    history.current_turn
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
  class << self
    def opponent; fail NotImplementedError; end
    def ussr?; false; end
    def us?; false; end
    def to_s; name.upcase; end
  end
end

class Us < Superpower; end
class Ussr < Superpower; end

US   = Us
USSR = Ussr

class Us < Superpower
  class << self
    def opponent; USSR; end
    def us?; true; end
  end
end

class Ussr < Superpower
  class << self
    def opponent; US; end
    def ussr?; true; end
  end
end

class VictoryTrack

  # +20 = USSR victory, -20 = US victory
  attr_reader :points

  def initialize
    @points = 0
  end

  def add(player, amount)
    raise ArgumentError, "Must be positive" if amount < 0

    @points += (player.us? ? -amount : amount)
  end

  def subtract(player, amount)
    raise ArgumentError, "Must be positive" if amount < 0

    @points += (player.us? ? amount : -amount)
  end
end

class Die
  attr_accessor :prng

  def initialize
    self.prng = Random.new
  end

  def roll
    [1,2,3,4,5,6].sample(random: prng)
  end
end

class History
  attr_accessor :entries

  def initialize
    self.entries = []
  end

  def add(entry)
    self.entries << entry
  end

  # Has the card been played as an event?
  # (This does not mean the event is necessarily in effect...)
  def played?(card)
    entries.any? { |e| Moves::CardPlay === e && e.card == card && e.event? }
  end

  def current_card
    x = entries.reverse.detect { |entry| entry.respond_to?(:card) }
    x.card
  end

  def current_turn
    x = entries.reverse.detect { |entry| entry.respond_to?(:turn) }
    x.turn
  end

  # Returns the most recent headline plays.
  def headlines
    entries.grep(Moves::HeadlineCardPlay).last(2)
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

  # The representation of playing a card. The resulting moves the player
  # may make are not part of a CardPlay.
  class CardPlay < Move
    # The player taking the action.
    attr_accessor :player

    # The card being played.
    attr_accessor :card

    # The action(s) the player wants to take as a result of playing the card.
    # If playing an opponent card, the player must specify :event and some
    # other action in the order they want to play them.
    #
    # This is affected by a case ruling, see Ruling #2.
    attr_accessor :actions_and_modifiers

    # injected as needed.
    attr_accessor :countries, :defcon, :current_turn, :score_resolver, :history

    # actions_and_modifiers may be one of:
    #   - a single symbol representing a single action,
    #   - an array of symbols representing an order of actions.
    #   - a hash keyed on action with each value being one or more
    #     modifiers to be applied with that action
    #
    # Examples:
    #
    #   :influence
    #   [:influence, :event]
    #   { :influence => [modifier1, modifier2], :event => nil }
    #
    def initialize(player, card, actions_and_modifiers)
      self.player = player
      self.card = card # TODO: check this can be played (i.e. is in hand)

      self.actions_and_modifiers = convert_to_hash(actions_and_modifiers)

      validate_actions(player, card)

      validate_modifiers(self.actions_and_modifiers)
      apply_modifiers(self.actions_and_modifiers)
    end

    # Convert input as described in constructor.
    def convert_to_hash(actions_and_modifiers)
      hash = case actions_and_modifiers
      when Hash   then actions_and_modifiers
      when Symbol then { actions_and_modifiers => nil }
      when Array  then Hash[actions_and_modifiers.zip([nil])]
      else raise "Unknown format: #{actions_and_modifiers}"
      end

      Hash[hash.map { |k,v| [k,[*v].compact] }]
    end

    def actions
      actions_and_modifiers.keys
    end

    def validate_actions(player, card)
      if exclusively_space_race?
        raise "Cannot space race." unless can_space_race?(player, card)

      elsif playing_opponent_card?(player, card)
        raise "Must be two actions" unless actions.size == 2
        raise "Must include event" unless event?
        raise "Must include an action" unless action?

      else
        raise "Player can only specify one action" unless actions.size == 1

        unless action? || event?
          raise "Must include an action or event"
        end
      end
    end

    def validate_modifiers(actions_and_modifiers)
      # TODO can these be used by the player?
      # i.e. is in game.modifiers and the current player owns them
      # and are active

      actions_and_modifiers.each do |action, modifiers|
        modifiers.each do |m|
          raise "Cannot use an expired modifier: #{m.inspect}" if m.expired?

          if m.unplayable?(action)
            raise "This modifier would cause an unplayable state"
          end
        end
      end
    end

    def apply_modifiers(actions_and_modifiers)
      modifiers = actions_and_modifiers.values.flatten

      card_play_modifiers = modifiers.select { |m| m.modifies?(self.class) }

      card_play_modifiers.each do |m|
        singleton_class.send :include, m.modifier_for(self.class)
      end
    end

    def exclusively_space_race?
      actions == [:space_race]
    end

    def event?
      actions.include?(:event)
    end

    # Any action (defined in Section 6) other than space race.
    def action?
      actions.any? { |e| [:influence, :coup, :realignment].include?(e) }
    end

    def playing_opponent_card?(player, card)
      card.side == player.opponent
    end

    # TODO
    def can_space_race?(*)
      true
    end

    def headline?; false; end

    # puts the card just played onto the expectation stack. Just like how
    # HeadlineCardRound does it after a couple of HeadlineCardPlays. BUT INSTEAD
    # IT DOES IT RIGHT NOW
    #
    # Returns one or more validators to be placed on the current set of
    # expectations.
    #
    # Execute can return a combination of validators and modifiers.
    def execute
      convert_actions(actions)
    end

    def convert_actions(actions)
      actions.
        map { |a| convert_action(a, card) }.
        flatten
    end

    # The rest of this smells a lot like a Factory...

    # Convert an action to a validator and/or modifier.
    def convert_action(action, card)

      actions_and_modifiers = []

      # If the event is playable, then fetch the validator and/or
      # modifier
      if action == :event
        if card.event_playable?(history)
          actions_and_modifiers.push card.validator.new if card.validator
          actions_and_modifiers.push card.modifier.new(player) if card.modifier

          # TODO
          todo "remove card" if card.remove_after_event?
        else
          puts "Event for #{card} does not execute!"
        end
      else
        validator_class = type_to_validator(action)
        number_of_moves = score_resolver.score(player, card)

        validator = instantiate_validator(validator_class, number_of_moves)

        actions_and_modifiers.push validator
      end

      actions_and_modifiers
    end

    def type_to_validator(type)
      class_name = type.to_s.split("_").map(&:capitalize).join

      Validators.const_get(class_name, false)
    end

    def instantiate_validator(validator_class, number_of_moves)
      # Doing a case on Class classes is not fun.
      case
      when validator_class == Validators::Influence
        validator_class.new(player,
                            accessible_countries(player, countries),
                            number_of_moves)

      when validator_class == Validators::Coup
        validator_class.new(player, defcon, number_of_moves)
      else
        raise "Don't know how to instantiate #{validator_class.inspect}!"
      end
    end

    def accessible_countries(player, countries)
      Country.accessible(player, countries).
        map { |name| Country.find(name, countries) }
    end

    def to_s
      x = actions_and_modifiers.map do |action, modifiers|
        [action, *modifiers].join(" with ")
      end

      "%s plays %s for %s" % [player, card, x.join(" then ")]
    end

    def amount
      raise "An amount is not required for a #{self.class.name}."
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


  #TODO: give these two classes a common abstract class.

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

    def resulting_influence
      country.influence(US) + amount
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
  end

  class Event < Move
    def initialize(player, todo)
    end

    def execute
      # ...
    end
  end

  class Coup < Move
    attr_accessor :player, :country

    # inject
    attr_accessor :current_card, :die, :score_resolver

    def initialize(player, country)
      self.player = player
      self.country = country
    end

    def can_coup?(defcon)
      country.presence?(player.opponent) &&
        country.defcon_permits_coup?(defcon)
    end

    def execute
      todo "reduce defcon (if battleground)"
      todo "increase military ops by score"

      stability = country.stability * 2

      n = die.roll

      score = score_resolver.score(player, current_card)

      modified_roll = n + score

      puts "%s rolls %s + %s = %s against a required %s modified stability" % [
        player, n, score, modified_roll, stability
      ]

      difference = modified_roll - stability

      if difference > 0
        puts "%s coups with %s point-win in %s" % [player, difference, country]

        country.successful_coup(player, difference)
      end
    end

    def to_s
      "%s attempts a coup in %s" % [player, country]
    end
  end

  # An alternate version of a Coup used in "free coup" moves that doesn't
  # test for geographic/defcon qualifiers (Section 6.3.5)
  class FreeCoup < Coup
    def can_coup?(defcon)
      country.presence?(player.opponent)
    end

    def to_s
      "%s attempts a FREE coup in %s" % [player, country]
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

  ### Misc, specialized moves

  class Discard < Move
    attr_accessor :player, :card

    def initialize(player, card)
      self.player = player
      self.card = card
    end

    def execute
      todo "discard the card from the player's hand"
    end

    def to_s
      "%s discards %s from their hand" % [player, card]
    end

  end

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

    attr_accessor :turn

    # injected
    attr_accessor :history

    def initialize(turn = 1)
      self.turn = turn
    end

    # Works out how to resolve the headline play that occurred.
    # Returns the next stack of expectations for appending?
    def execute
      # TODO: if a tie on card score, US goes first (Rule 4.5 Subsection C)
      # Starting with the highest score, build up expectations
      validators = history.headlines.
        sort_by { |h| h.card.score! }.
        map     { |h| h.card.validator.new }.
        reverse

      puts "HEADLINE CARDS PLAYED!"

      # TODO: maybe update game status here about cards played

      Expectations.new(validators, :terminator => HeadlineEventsEnd.new(turn))
    end
  end

  # A class for processing the end of events being played in the headline
  # round.
  class HeadlineEventsEnd

    attr_accessor :turn

    def initialize(turn)
      self.turn = turn
    end

    def execute
      puts "HEADLINE PHASE ENDED!"

      validators = [
        Validators::CardPlay.new(USSR),
        Validators::CardPlay.new(US)
      ]

      Expectations.new(
        validators,
        :terminator => Terminators::ActionRoundEnd.new(turn)
      )
    end
  end

  # Handles the end of each action round. There are multiple action rounds
  # per turn.
  class ActionRoundEnd

    attr_accessor :turn, :counter

    def initialize(turn, counter = 1)
      self.turn = turn
      self.counter = counter
    end

    def execute
      puts "ACTION ROUND ENDED!"

      t = if (turn <= 3 && counter == 6) || (turn >= 4 && counter == 7)
        Terminators::TurnEnd.new(turn)
      else
        Terminators::ActionRoundEnd.new(turn, counter + 1)
      end

      validators = [
        Validators::CardPlay.new(USSR),
        Validators::CardPlay.new(US)
      ]

      Expectations.new(validators, :terminator => t)
    end
  end

  # Handles the end of each turn. There are multiple turns per phase.
  class TurnEnd
    attr_accessor :turn

    def initialize(turn)
      self.turn = turn
    end

    def execute
      puts "TURN ENDED!"

      if turn == 10 then
        Expectations.new([], :terminator => Terminators::GameEnd.new)
      else
        # if *end of* turn 3 ... etc
        if turn == 3 then
          todo "merge in mid war cards"
        elsif turn == 6 then
          todo "merge in late war cards"
        end

        Expectations.new([],
          :terminator => Terminators::HeadlineCardRound.new(turn + 1))
      end
    end
  end

  class GameEnd
    def turn
    end

    def execute
      puts "GAME ENDED"
    end
  end
end

module Validators
  class Validator
    def satisfied?
      fail NotImplementedError, "#{self.class.name} did not impl"
    end

    def execute(move)
      retval = move.execute
      executed(move)
      retval
    end

    def executed(move)
    end

    def valid?(move)
      fail NotImplementedError, "#{self.class.name} did not impl"
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
      Moves::Influence === move && super
    end
  end

  module UnrestrictedInfluenceHelper
    include TypeAgnosticInfluenceHelper

    def valid?(move)
      Moves::UnrestrictedInfluence === move && super
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
      fail NotImplementedError, "not impl in #{self.class.name}"
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

    include SingleExecutionHelper

    # Move is valid if any of:
    #  - discards a card >= 3 ops
    #  - requests to remove *all* influence from west germany
    def valid?(move)
      move.player.us? && (discard?(move) || deinfluences?(move))
    end

    def discard?(move)
      Moves::Discard === move && move.card.score >= 3
    end

    def deinfluences?(move)
      Moves::UnrestrictedInfluence === move &&
        move.country.name == "West Germany" &&
        move.resulting_influence.zero?
    end
  end

  class VietnamRevolts < Validator

    include UnrestrictedInfluenceHelper

    def initialize
      self.remaining_influence = 2
    end

    def valid?(move)
      super && move.player.ussr? && move.country.name == "Vietnam"
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
      Moves::HeadlineCardPlay === move && move.player == expected_player
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
      Moves::CardPlay === move && move.player == expected_player
    end
  end

  # An Influence validator that applies the rules of placing influence during
  # operations. It will test for the target country being whitelisted, as well
  # as ensuring 2:1 cost of entry during opponent control.
  class Influence < Validator
    attr_accessor :expected_player, :countries

    include InfluenceHelper

    def initialize(expected_player, countries, number_of_moves)
      self.expected_player = expected_player
      self.countries = countries
      self.remaining_influence = number_of_moves
    end

    def valid?(move)
      super &&
        expected_player == move.player &&
        countries.include?(move.country) &&
        move.affordable?
    end
  end

  class Coup < Validator
    attr_accessor :expected_player, :defcon, :points

    include SingleExecutionHelper

    def initialize(expected_player, defcon, points)
      self.expected_player = expected_player
      self.points = points
      self.defcon = defcon
    end

    def valid?(move)
      move.player == expected_player && move.can_coup?(defcon)
    end
  end
end

class Modifiers
  attr_accessor :modifiers

  include Enumerable

  def initialize
    self.modifiers = []
  end

  def each(&block)
    modifiers.select(&:active?).each(&block)
  end

  def insert(*modifiers)
    self.modifiers.push(*modifiers)
  end

  def executed(something)
    map { |m| m.executed(something) }
  end
end

class Modifiers
  # A Modifier is a persistent object that will stay around modifying certain
  # aspects of gameplay until it renders itself to be no longer active.
  #
  # Modifiers receive notifications of all actions, move and terminators that
  # are executed in order to manage their internal state over multiple plays.
  class Modifier
    def executed(something)
    end

    def modifies?(klass)
      modifier_for(klass)
    end

    def modifier_for(klass)
    end

    def active?
      raise NotImplementedError
    end

    def expired?
      !active?
    end

  end

  module ScoreModifier
    def score(current_player, card)
      raise NotImplementedError
    end
  end

  # Card Text
  # ---------
  #
  # All Operations cards played by the opponent, for the remainder of this
  # turn, receive -1 to their Operations value (to a minimum value of 1
  # Operations point).
  #
  class RedScarePurge < Modifier

    include ScoreModifier

    # The player that activated this modifier.
    attr_accessor :activating_player

    def initialize(activating_player)
      self.activating_player = activating_player

      @active = true
    end

    def score(current_player, card)
      current_player == activating_player.opponent && card.score! > 1 ? -1 : 0
    end

    def executed(something)
      @active = false if Terminators::TurnEnd === something
    end

    def active?
      @active
    end

    def to_s
      "%s reduces card ops by 1 point for %s" % [
        self.class.name, activating_player.opponent]
    end
  end

  class Containment < Modifier

    include ScoreModifier

    def initialize(*)
      @active = true
    end

    def score(current_player, card)
      current_player.us? && card.score! < 4 ? 1 : 0
    end

    def executed(something)
      @active = false if Terminators::TurnEnd === something
    end

    def active?
      @active
    end

    def to_s
      "%s increases card ops by 1 point for US" % self.class.name
    end

  end

  class VietnamRevolts < Modifier

    attr_accessor :activating_player

    # injected
    attr_accessor :score_resolver, :countries

    def initialize(activating_player)
      self.activating_player = activating_player

      @active = true
    end

    def executed(something)
      @active = false if Terminators::TurnEnd === something
    end

    def active?
      @active
    end

    # In order to be playable as influence, the activating player
    # must have presence in at least one country in SE Asia.
    #
    # In order to be playable with a coup or realignment, then the
    # same rule must be true for the opponent.
    def playable?(action)
      player = case action
      when :influence          then activating_player
      when :realignment, :coup then activating_player.opponent
      else false
      end

      Country.accessible(player, countries).
        map  { |c| Country.find(c, countries) }.
        any? { |c| c.in?(SoutheastAsia) }
    end

    def unplayable?(action)
      !playable?(action)
    end

    # Methods that overlay CardPlay
    module CardPlayModifier
      def instantiate_validator(validator_class, number_of_moves)
        super(validator_class, number_of_moves + 1)
      end

      def accessible_countries(player, countries)
        accessible_countries = super

        accessible_countries.select { |c| c.in?(SoutheastAsia) }
      end
    end

    def modifier_for(klass)
      return CardPlayModifier if klass == Moves::CardPlay
    end

    def to_s
      "%s increases ops by 1 point for %s card play entirely within SE Asia" % [
        self.class.name, activating_player
      ]
    end
  end

  class Nato < Modifier

    def initialize(*)
      @active = true
    end

    def active?
      @active
    end

    # TODO: Implement NATO patches
    #
    # Remove european us-controlled countries from accessible_countries
    # for coups, realignment and brush war.
    #
    # patch Moves::Coup, Moves::Realignment and Moves::CardPlay (for BrushWar)
  end
end

class ScoreResolver

  attr_accessor :modifiers

  def initialize(modifiers)
    self.modifiers = modifiers
  end

  def score(player, card)
    score = card.score!

    score_modifiers = modifiers.grep(Modifiers::ScoreModifier)

    score_modifiers.each do |m|
      adjustment = m.score(player, card)

      puts "%s adjusts ops points by %s for %s" % [
        m.class.name, adjustment, player
      ]

      score += adjustment
    end

    score
  end
end


# A registry for cards.
class Cards
  class << self
    def all
      @cards || []
    end

    def add(card)
      @cards ||= []
      @cards << card
    end

    def early_war
      all.select { |c| c.phase == :early }
    end
  end
end

class Card

  FIELDS = [
    :id, :name, :ops, :side, :phase, :remove_after_event, :validator, :modifier
  ]

  attr_accessor *FIELDS

  alias remove_after_event? remove_after_event

  def initialize(args)
    # Don't require modifier
    args[:modifier] ||= nil

    unless (FIELDS - args.keys).empty?
      raise ArgumentError, "missing args: #{(FIELDS - args.keys).join(',')}"
    end

    args.each { |key, value| send("#{key}=", value) }
    add_to_registry
  end

  def add_to_registry
    Cards.add(self)
  end

  # If the card is played for the event, is the event executable given the
  # current history?
  def event_playable?(history)
    true
  end

  def ops
    raise "Don't get the score here. Use a ScoreResolver."
  end

  alias score ops

  def ops!
    @ops
  end

  alias score! ops!

  def to_s
    asterisk = remove_after_event ? "*" : nil

    "%s%s (%s) [%s, %s]" % [name, asterisk, ops!, side || "neutral", phase]
  end
end

# Nato is special, it:
#
#  can be played for an event, but the event may not execute, depending on
#  previous card plays
#
#  must be discarded after the event has run (card can be played for event,
#  but if the event doesnt execute due to above conditions, discard should
#  not occur)
#
#
class NatoCard < Card

  # TODO: remove these ghost classes once cards are defined
  class WarsawPact; end
  class MarshallPlan; end

  def event_playable?(history)
    history.played?(WarsawPact) || history.played?(MarshallPlan)
  end

end

# Sample cards
# TODO: namespace... module Cards?
require "allcards"

class Deck
  attr_accessor :cards, :backup

  def initialize(cards = [], backup = nil)
    self.cards = cards.shuffle
    self.backup = backup
  end

  def draw
    card = cards.shift

    if card
      card
    elsif backup
      # TODO not good enough simply draw from back up deck - understanding
      # is this should become the new primary deck (and shuffle it!)
      backup.draw or fail NoCardsError, "No cards in deck or backup."
    else
      fail NoCardsError, "No cards in deck and no backup provided."
    end
  end

  NoCardsError = Class.new(StandardError)
end

class Hand
  attr_reader :player, :cards

  def initialize(player, cards = [])
    @player = player
    @cards = cards
  end

  def discard(card)
    @cards.delete(card) or fail "Card #{card.inspect} not found in hand."
  end

  def add(cards)
    @cards.push *cards
  end
end


class Country

  NO_COUPS = {
    5 => [],
    4 => [Europe],
    3 => [Europe, Asia],
    2 => [Europe, Asia, MiddleEast]
  }

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

  def add_influence!(player, amount = 1)
    @influence.fetch(player) && @influence[player] += amount
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
  #
  # TODO this may not be needed - use Country.accessible to build a whitelist
  # of countries that can receive influence
  def can_add_influence?(player, countries)
    if countries.include?(self)
      presence?(player) || player_in_neighboring_country?(player, countries)
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

  # Coup methods

  def defcon_prevents_coup?(defcon)
    return true if defcon == 1 # should you even be asking at this juncture?

    regions = NO_COUPS[defcon]

    # Is this country in any of the DEFCON-affected regions?
    regions.any? { |region| in?(region) }
  end

  def defcon_permits_coup?(defcon)
    !defcon_prevents_coup?(defcon)
  end

  # Effect the change of a successful coup by the given player with given
  # margin of victory.
  def successful_coup(player, amount)
    raise ArgumentError, "must be positive" if amount < 0

    amount.times do
      if presence?(player.opponent)
        add_influence! player.opponent, -1
      else
        add_influence! player, 1
      end
    end
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
      name = Regexp.new(name.to_s.gsub(/_/, " "), :i)

      results = countries.select do |country|
        country.name =~ name
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
    def accessible(player, all_countries)
      accessible_countries = []

      all_countries.each do |country|
        if country.presence?(player)
          accessible_countries.push country.name
          accessible_countries.push *country.neighbors
        elsif country.player_adjacent_to_superpower?(player)
          accessible_countries.push country.name
        end
      end

      accessible_countries.uniq
    end
  end

  AmbiguousName = Class.new(RuntimeError)
end

# Real bits of mostly unimportant code
class Game

  # Start a new game
  def initialize
    self.discarded = Deck.new
    self.removed = Deck.new

    self.deck = Deck.new(Cards.early_war, discarded)

    self.us_hand = Hand.new(US)
    self.ussr_hand = Hand.new(USSR)

    self.history = History.new

    self.turn = 0 # headline
    self.round = 1
    self.player = USSR

    self.defcon = 5

    self.china_card_playable = true
    self.china_card_holder = USSR

    self.us_ops = 0
    self.ussr_ops = 0

    self.countries = Country.initialize_all

    self.victory_track = VictoryTrack.new

    self.die = Die.new

    self.modifiers = Modifiers.new

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

    # TODO INCREASE TO EIGHT
    2.times do
      us_hand.add(deck.draw)
      ussr_hand.add(deck.draw)
    end
  end

  def status
    puts "game status..."
  end

  def score_resolver
    ScoreResolver.new(modifiers)
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
