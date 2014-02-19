module Arguments
  def fancy_accessor(*args)
    @__args ||= []
    @__args.push(*args)

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

  def arguments
    @__args || []
  end
end

class Object
  include Arguments
end
