module Arguments
  def fancy_accessor(*args)
    @__args ||= []
    @__args.push(*args)

    attr_accessor(*args)
  end

  def arguments
    (defined?(@__args) && @__args) || []
  end
end

class Object
  include Arguments
end
