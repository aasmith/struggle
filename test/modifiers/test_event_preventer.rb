require "helper"

class EventPreventerTest < Struggle::Test

  attr_reader :preventer

  def setup
    @preventer = Modifiers::Permission::EventPreventer.new(
      event_name: "Bad"
    )
  end

  def test_denies_move
    move = EmptyMove.new(instruction: Bad.new)

    refute preventer.allows?(move)
  end

  def test_denies_instruction
    refute preventer.allows?(Bad.new)
  end

  def test_allows_move
    move = EmptyMove.new(instruction: Good.new)

    assert preventer.allows?(move)
  end

  def test_allows_instruction
    assert preventer.allows?(Good.new)
  end

  Good = Class.new EmptyInstruction
  Bad  = Class.new EmptyInstruction

end
