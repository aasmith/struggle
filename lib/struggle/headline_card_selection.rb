
# Encapsulates a card that has been selected by a given player for headline
# play. Instances can be sorted per Rule 4.5.C.

class HeadlineCardSelection

  include Comparable

  attr_accessor :player, :card

  def initialize(player, card)
    @player = player
    @card = card
  end

  # Lower is better
  def <=>(other)
    raise "Players must differ" if player == other.player

    case
    when card.always_evaluate_first?
      -1
    when other.card.always_evaluate_first?
      1
    when same_headline_value?(other)
      player.headline_priority <=> other.player.headline_priority
    else
      card.headline_value <=> other.card.headline_value
    end
  end

  def same_headline_value?(other)
    card.headline_value == other.card.headline_value
  end
end
