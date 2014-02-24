class Instruction < WorkItem
  def execute
    result = action
    complete
    result
  end

  def action
    raise NotImplementedError
  end

  def inspect
    args = self.class.arguments.map do |a|
      "%s: %s" % [a, send(a).inspect]
    end

    "%s(%s)" % [self.class.name.sub(/^Instructions/, "I"), args.join(", ")]
  end
end
