require "minitest/autorun"

require "struggle"

class TestSuperpowers < Minitest::Test

  def test_no_instantiations
    [Superpower, US, USSR].each do |klass|
      assert_raises ArgumentError do
        klass.new
      end
    end
  end

  def test_us
    assert_equal US, Us
    assert_equal "US", US.name
    assert_equal "US", US.to_s

    assert US.us?
    refute US.ussr?

    assert_equal USSR, US.opponent

    assert_equal "☆", US.symbol
  end

  def test_ussr
    assert_equal USSR, Ussr
    assert_equal "USSR", USSR.name
    assert_equal "USSR", USSR.to_s

    refute USSR.us?
    assert USSR.ussr?

    assert_equal US, USSR.opponent

    assert_equal "☭", USSR.symbol
  end

end
