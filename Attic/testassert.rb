require 'minitest'
require 'minitest/assertions'

class Derp < Minitest::Runnable
  include Minitest::Assertions

  attr_accessor :assertions
  def initialize
    self.assertions = 0
  end
end

class Foo
  def lol
    Derp.new.assert(false, "lol should be true")
  end
end

Foo.new.lol
