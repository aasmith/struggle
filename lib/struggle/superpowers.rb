class Superpower
  class << self
    def opponent; fail NotImplementedError; end
    def headline_priority; fail NotImplementedError; end # lower is better
    def ussr?; false; end
    def us?; false; end
    def to_s; name; end
    def name; super.upcase; end
    def symbol; end
  end

  def initialize; fail ArgumentError, "Cannot instantiate a Superpower!"; end
end

class US < Superpower
  class << self
    def opponent; USSR; end
    def headline_priority; -1; end
    def us?; true; end
    def symbol; "☆"; end
  end
end

class USSR < Superpower
  class << self
    def opponent; US; end
    def headline_priority; 1; end
    def ussr?; true; end
    def symbol; "☭"; end
  end
end
