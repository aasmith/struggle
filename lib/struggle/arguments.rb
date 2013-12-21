module Arguments
  def arguments(*args)
    @args ||= []
    @args.push(*args)

    if args.empty?
      @args
    else
      attr_accessor(*args)
    end
  end
end

class ArgumentProvider
  def initialize(target)
    @target = target
  end

  def provide(args)
    # SMELL: Re-implement something ruby already does... :(
    if (expected = @target.class.arguments.size) != (actual = args.size)
      raise ArgumentError, "Expected %s args, got %s" % [expected, actual]
    end

    @target.class.arguments.zip(args).each do |name, value|
      @target.send("#{name}=", value)
    end
  end
end

