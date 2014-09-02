##
# Represents the current state of the china card with regard to ownership
# and playability.
#
class ChinaCard
  attr_accessor :holder, :playable

  def initialize
    @holder = USSR
    @playable = true
  end

  def flip_up
    @playable = true
  end

  def use
    @playable = false
  end

  def playable?
    @playable
  end

  def transfer(superpower = holder.opponent)
    @holder = superpower
  end

  def transfer_ready_for_play(superpower = holder.opponent)
    transfer(superpower)
    flip_up
  end

  def playable_by?(player)
    playable? && holder == player
  end
end
