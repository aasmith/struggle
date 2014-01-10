module Arguments
  def arguments(*args)
    @args ||= []
    @args.push(*args)

    if args.empty?
      @args
    else
      attr_writer(*args)

      # Add an accessor that will delegate to +obj.value+ if +obj+ responds to
      # +value+. Delegated results are not cached.
      #
      # Passing +unbox: false+ to the accessor will always return +obj+.
      args.each do |arg|
        define_method(arg) do |unbox: true|
          iv = instance_variable_get(:"@#{arg}")

          unbox && iv.respond_to?(:value) ? iv.value : iv
        end
      end
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

