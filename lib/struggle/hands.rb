class Hands

  def initialize
    @hands = { USSR => [], US => [] }
  end

  def add(player, card)
    @hands.fetch(player) << card
  end

  def remove(player, card)
    @hands.fetch(player).delete(card)
  end

  def get(player)
    @hands.fetch(player).dup.freeze
  end

  alias hand get

  def clear(player)
    @hands.fetch(player).clear
  end
end

