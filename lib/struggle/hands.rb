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

  # A duplicated and frozen hand for +player+.
  #
  # Modifications will raise an error.
  #
  def get(player)
    get!(player).freeze
  end

  # Returns +player+ hand with a duplicated array that is not frozen.
  #
  # Any changes the caller makes to the array will be not be made
  # to the underlying hand.
  #
  def get!(player)
    @hands.fetch(player).dup
  end

  alias hand  get
  alias hand! get

  def clear(player)
    @hands.fetch(player).clear.dup.freeze
  end

  def inspect
    "<Hands: US: %s cards, USSR: %s cards>" % [get(US).size, get(USSR).size]
  end
end

