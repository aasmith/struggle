class Instruction < WorkItem
  def execute
    returning action do
      complete
    end
  end

  def action
    noimpl
  end

  ##
  # Returns +obj+ after calling +block+.
  #
  def returning(obj, &block)
    obj.tap(&block)
  end

  def inspect
    args = self.class.arguments.map do |a|
      "%s: %s" % [a, send(a).inspect]
    end

    "%s(%s)" % [self.class.name.sub(/^Instructions/, "I"), args.join(", ")]
  end
end
