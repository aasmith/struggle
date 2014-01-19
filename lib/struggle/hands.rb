class Hands

  def initialize
    @hands = { USSR => [], US => [] }
  end

  def add(player, card)
    (@hands.fetch(player) << card).dup.freeze
  end

  def remove(player, card)
    @hands.fetch(player).delete(card)
  end

  def get(player)
    @hands.fetch(player).dup.freeze
  end

  alias hand get

  def clear(player)
    @hands.fetch(player).clear.dup.freeze
  end

  def inspect
    "<Hands: US: %s cards, USSR: %s cards>" % [get(US).size, get(USSR).size]
  end
end

