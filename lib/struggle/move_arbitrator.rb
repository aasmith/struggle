class MoveArbitrator < WorkItem
  def initialize(**args)
    super

    @stashed_moves = []
    @executed_moves = []
  end

  def accepts?(move)
    raise NotImplementedError
  end

  def accept(move)
    before_execute(move)
    results = [*move.execute]
    after_execute(move)

    results.all? { |r| WorkItem === r } ? results : []
  end

  # Override in subclasses.
  def after_execute(move)
    complete
  end

  # Override in subclasses.
  def before_execute(move)
  end

  def stash(move)
    @stashed_moves.push move
  end

  def execute_stashed_moves
    while move = @stashed_moves.pop do
      results = *accept(move)
      @executed_moves.push move

      # There are some things to put on the engine stack, so
      # stop executing stuff here and let the engine run the
      # new stuff we are about to give it.
      return results if results
    end
  end

  def correct_player?(move)
    # XXX
    #
    # UGH - this surfaces the whole 'do we need a player attr on Move and
    # sometimes on the Instruction as well' problem. At least ringfence it
    # into here for now.
    #
    # XXX
    instruction_player =
      move.instruction &&
      move.instruction.respond_to?(:player) &&
      move.instruction.player

    instruction_player ?
      player == instruction_player && player == move.player :
      player == move.player
  end

  def incorrect_player?(move)
    !correct_player?(move)
  end

end

