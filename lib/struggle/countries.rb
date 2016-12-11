class Countries

  include Enumerable

  def initialize(data)
    @countries = data.map do |row|
      Array === row ? Country.new(*row) : row
    end
  end

  def initialize_copy(orig)
    @countries = @countries.map(&:dup)
  end

  ##
  # Looks through the given array of countries for an unambiguous
  # match on country name. Name can be a String or Symbol.
  #
  # Not finding a country with the given name is considered an error.
  #
  def find(name)
    name = /^#{name.to_s.gsub('_', ' ')}/i

    results = @countries.select do |country|
      country.name =~ name
    end

    if results.size == 1
      return results.first
    elsif results.size > 1
      raise AmbiguousNameError, "#{name.inspect} is ambiguous"
    else
      raise CountryNotFoundError, "No country found for #{name.inspect}"
    end
  end

  def each(&block)
    @countries.each(&block)
  end

  def inspect
    "<Countries ...>"
  end

  AmbiguousNameError = Class.new(ArgumentError)
  CountryNotFoundError = Class.new(RuntimeError)
end

