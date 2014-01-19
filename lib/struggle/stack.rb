
class Stack
  def initialize
    @items = []
  end

  def push(*items)
    @items.unshift(*items)
  end

  def pop
    @items.shift
  end

  def peek
    @items.first
  end

  ##
  # 'Watches' the stack for any insertions or removals during execution of
  # +block+. If the stack has changed, then true is returned.
  def monitor(&block)
    raise ArgumentError, "no block provided" unless block_given?

    before = @items.dup

    block.call

    after = @items

    before != after
  end
end

