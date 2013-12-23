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

  def required_arguments
    @target.class.arguments
  end

  def provide(**args)
    extra = args.keys - required_arguments
    missing = required_arguments - args.keys

    unless extra.empty?
      raise ArgumentError, "#{@target.class} too many args: #{extra.inspect}"
    end

    unless missing.empty?
      raise ArgumentError, "#{@target.class} missing args: #{missing.inspect}"
    end

    args.each { |k,v| @target.send("#{k}=", v) }
  end
end

