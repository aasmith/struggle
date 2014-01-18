## EXAMPLE MODELS

### Instructions

module Instructions

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

  class If < Instruction
    def initialize(cond, cond_true, cond_false)
    end

    def action
      NestingInstruction.new(*cond ? cond_true : cond_false)
    end
  end
end

### Modifiers

##
# Always says no to every move.
#
# Used for testing.
#
class NegativePermissionModifier
  def allows?(move)
    false
  end
end

class StackModifier
  def initialize(*items_to_insert)
    @items_to_insert = items_to_insert
    @executed = false # execute this only once
  end

  def notify(event, move, work_items)
    return if @executed

    work_items.push(*@items_to_insert)

    @executed = true
  end
end


class PermissionModifier
  extend Injectible

  def allows?(move)
    raise NotImplementedError
  end
end

##
# Updates and consults with the SpaceRace class to ensure each move is
# made in compliance with current space race restrictions.
#
class SpaceRacePermissionModifier < PermissionModifier

  needs :space_race

  def allows?(move)
    return true # TODO
    # note move and see if space race will allow it.
    #
    # update space race component.
    #
    # if spacing and player has used up space race, return false.
  end
end

##
# Rejects any attempt to play the China Card as an event.
#
# Should be present as a permission modifier throughout the game.
#
class ChinaCardPermissionModifier < PermissionModifier

  needs :cards, :china_card

  def allows?(move)
    !eventing_china_card?(move)
  end

  def eventing_china_card?(move)
    return false unless Instructions::PlayCard === move

    card = cards.find_by_ref(move.instruction.card_ref)

    card.china_card? && move.instruction.card_action == :event
  end
end

