## EXAMPLE MODELS

### Moves

class Move
  attr_accessor :player, :instruction

  def initialize(player: nil, instruction: nil)
    self.player = player
    self.instruction = instruction
  end

  def execute
    instruction.execute
  end

  def executed?
    noimpl
  end
end


class CardPlay < Move
  attr_accessor :operation, :card
end

### Misc

def noimpl() raise("%s Not Implemented" % [caller_locations.first.to_s]) end

### WorkItem

class WorkItem
  extend Injectible
  extend Arguments

  def initialize(**args)
    @complete = false

    ap = ArgumentProvider.new(self)
    ap.provide(args)

    after_init
  end

  def after_init
  end

  def complete?() @complete end
  def incomplete?() !complete?() end

  private

  def complete
    @complete = true
  end
end


### Instructions

module Instructions
  class Instruction < WorkItem
    def execute
      returning action do
        complete
      end
    end

    def action
      noimpl
    end

    ##
    # Returns +obj+ after calling +block+.
    #
    def returning(obj, &block)
      obj.tap(&block)
    end

    def inspect
      args = self.class.arguments.map do |a|
        "%s: %s" % [a, send(a).inspect]
      end

      "%s(%s)" % [self.class.name.sub(/^Instructions/, "I"), args.join(", ")]
    end
  end

  # Used for testing.
  class EmptyInstruction < Instruction
    def action
    end
  end

  # Used for testing.
  class LambdaInstruction < Instruction
    def initialize(*, &block)
      @block = block
    end

    def action
      @block.call
    end
  end

  class NestingInstruction < Instruction
    def initialize(*instructions)
      unless instructions.all? { |i| WorkItem === i }
        bad = instructions.reject { |i| i.is_a? WorkItem }
        raise "Bad list items: #{bad.inspect}"
      end

      @instructions = instructions
    end

    def action
      @instructions
    end
  end

  class AwardVictoryPoints < Instruction
    arguments :player, :amount

    needs :victory_point_track

    def action
      victory_point_track.award(player, amount)
    end
  end

  ##
  # Adds influence to a country, no questions asked.
  #
  # Requires the Countries registry.
  #
  class AddInfluence < Instruction
    arguments :influence, :amount, :country_name

    needs :countries

    def action
      countries.find(country_name).add_influence(influence, amount)
    end
  end

  class AddToDeck < Instruction
    arguments :phase

    needs :cards, :deck

    def action
      deck.add(cards.select { |c| c.phase == phase && !c.china_card? })
    end
  end

  class ClaimChinaCard < Instruction
    arguments :player, :playable

    needs :china_card

    def action
      china_card.holder = player
      china_card.playable = playable
    end
  end

  class SurrenderChinaCard < Instruction
    needs :china_card

    def action
      china_card.holder = china_card.holder.opponent
      china_card.playable = false
    end
  end

  class SetPhasingPlayer < Instruction
    arguments :player

    needs :phasing_player

    def action
      phasing_player.player = player
    end
  end

  class ImproveDefcon < Instruction
    needs :defcon

    def action
      defcon.improve(1)
    end
  end

  ##
  # Deals cards from the deck. If there are no more cards in the deck,
  # the +discard+ pile is transferred into the deck.
  #
  class DealCards < Instruction
    arguments :target

    needs :deck, :hands, :discards

    def action
      satisfied = { US => false, USSR => false }

      until satisfied.values.all? do
        [USSR, US].each do |player|
          if hands.get(player).size < target
            if deck.empty?
              deck.add discards
              discards.clear
            end

            hands.add(player, deck.draw)
          else
            satisfied[player] = true
          end
        end
      end
    end
  end

  class FlipChinaCard < Instruction
    needs :china_card

    def action
      china_card.flip_up
    end
  end

  class AdvanceTurn < Instruction
    needs :turn

    def action
      turn.advance
    end
  end

  class CheckHeldCards < Instruction
    needs :hands

    def action
      # Order is important here -- if both players are holding scoring cards
      # then USSR loses.

      return winner(US)   if hands.get(USSR).any?(&:scoring?)
      return winner(USSR) if hands.get(US).any?(&:scoring?)
    end

    def winner(player)
      [DeclareWinner.new(player: player), EndGame.new]
    end
  end

  class CheckMilitaryOps < Instruction
    needs :military_ops, :defcon

    def action
      result = military_ops.calculate_vp(defcon)

      if result.vp > 0
        return AwardVictoryPoints(player: result.player, amount: result.vp)
      end
    end
  end

  class ResetMilitaryOps < Instruction
    needs :military_ops

    def action
      military_ops.reset
    end
  end

  class DeclareWinner < Instruction
    arguments :player

    needs :victory

    def action
      victory.winner = player
    end
  end

  class FinalScoring < Instruction

    def action
    end
  end

  class EndGame < Instruction
    needs :victory

    # Set game.over = true. Winner should be set by another instruction. if
    # not set, then winner will be nil and a draw is assumed.
    def action
      puts "GAME OVER: Winner #{victory}"
    end
  end

end

### MoveArbitrators

module Arbitrators
  class MoveArbitrator < WorkItem
    def initialize(**args)
      super

      @stashed_moves = []
      @executed_moves = []
    end

    def accepts?(move) noimpl end

    def accept(move)
      move.execute
      after_execute(move)
    end

    # Override in subclasses.
    def after_execute(move)
      complete
    end

    def stash(move)
      @stashed_moves.push move
    end

    def execute_stashed_moves
      while move = @stashed_moves.pop do
        accept move
        @executed_moves.push move
      end
    end

    def hint() noimpl end
  end

  class AddInfluence < MoveArbitrator
    arguments :player, :influence, :country_names, :total_influence

    attr_reader :remaining_influence

    def after_init
      @remaining_influence = total_influence
    end

    def after_execute(move)
      @remaining_influence -= move.instruction.amount

      complete if @remaining_influence.zero?
    end

    # TODO use minitest assertions?
    def accepts?(move)
      move.player == player &&
        move.instruction.influence == influence &&
        country_names.include?(move.instruction.country_name) &&
        move.instruction.amount <= remaining_influence
    end
  end

  class WipCardPlay < MoveArbitrator
    arguments :player

    needs :space_race, :hands

    def accepts?(move)
      # check space race eligibility
      # check card in hand
    end
  end
end

### Modifiers

class NegativePermissionModifier
  def allows?(move)
    false
  end
end

class StackModifier
  def initialize(*items_to_insert)
    @items_to_insert = items_to_insert
    @seen = false # execute this only once
  end

  def notify(event, move, work_items)
    return if @seen

    work_items.push(*@items_to_insert)

    @seen = true
  end
end

