
class Stack
  def initialize
    @stack = []
  end

  def push(*items)
    @stack.unshift(*items)
  end

  def pop
    @stack.shift
  end

  def peek
    @stack.first
  end

  ##
  # 'Watches' the stack for any insertions or removals during execution of
  # +block+. If the stack has changed, then true is returned.
  def stack_changed?(&block)
    raise ArgumentError, "no block provided" unless block_given?

    before = @stack.dup

    block.call

    after = @stack

    before != after
  end
end

