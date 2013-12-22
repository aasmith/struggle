class Deck
  def initialize
    @cards = []
  end

  def draw
    raise EmptyDeckError if @cards.empty?

    @cards.pop
  end

  def add(more)
    @cards.push(*more)
    @cards.shuffle!

    nil # Don't leak the order of cards
  end

  def empty?
    @cards.empty?
  end

  EmptyDeckError = Class.new(RuntimeError)
end
