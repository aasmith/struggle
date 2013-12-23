class Hands

  def initialize
    @hands = { USSR => [], US => [] }
  end

  def add(player, card)
    @hands.fetch(player) << card
  end

  def get(player)
    @hands.fetch(player).dup.freeze
  end
end

