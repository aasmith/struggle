class Superpower
  class << self
    def opponent; fail NotImplementedError; end
    def ussr?; false; end
    def us?; false; end
    def to_s; name; end
    def name; super.upcase; end
    def symbol; end
  end

  def initialize; fail ArgumentError, "Cannot instantiate a Superpower!"; end
end

class Us < Superpower; end
class Ussr < Superpower; end

US   = Us
USSR = Ussr

class Us < Superpower
  class << self
    def opponent; USSR; end
    def us?; true; end
    def symbol; "☆"; end
  end
end

class Ussr < Superpower
  class << self
    def opponent; US; end
    def ussr?; true; end
    def symbol; "☭"; end
  end
end
