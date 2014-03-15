require "helper"

class TestDefcon < Struggle::Test

  def test_initialize
    defcon = Defcon.new
    assert_equal 5, defcon.value

    defcon = Defcon.new 3
    assert_equal 3, defcon.value
  end

  def test_degrade
    defcon = Defcon.new
    defcon.degrade(1)

    assert_equal 4, defcon.value

    assert_raises ArgumentError, "Should not allow negative values" do
      defcon.degrade(-1)
    end

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.degrade(10)
    end

    assert_equal 4, defcon.value, "Should still be at previous setting"
  end

  def test_improve
    defcon = Defcon.new 3

    defcon.improve(1)
    assert_equal 4, defcon.value

    assert_raises ArgumentError, "Should not allow negative values" do
      defcon.improve(-1)
    end

    assert_equal 4, defcon.value, "Should still be at previous setting"
  end

  def test_set
    defcon = Defcon.new

    defcon.set(3)
    assert_equal 3, defcon.value

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.set(6)
    end

    assert_raises InvalidDefcon, "Should not allow value outside of range" do
      defcon.set(0)
    end

    assert_equal 3, defcon.value, "Should still be at previous setting"
  end

  def test_one?
    defcon = Defcon.new
    refute defcon.one?

    defcon.set(2)
    refute defcon.one?

    defcon.degrade(1)
    assert defcon.one?

    assert_raises(ImmutableDefcon, "Setting DEFCON after war should fail") do
      defcon.improve(2)
    end
  end

  def test_defcon_maxes_at_five
    defcon = Defcon.new

    defcon.improve(1)

    assert_equal 5, defcon.value
  end

  def test_restricted_regions
    defcon = Defcon.new(1)

    assert_raises ArgumentError do
      defcon.restricted_regions
    end

    (2..4).each do |i|
      defcon = Defcon.new(i)
      refute_empty defcon.restricted_regions
    end

    defcon = Defcon.new(5)
    assert_empty defcon.restricted_regions
  end

  def test_affects_country?
    kenya = FakeCountry.new([Africa])
    burma = FakeCountry.new([Asia, SoutheastAsia])

    defcon = Defcon.new(3)

    assert defcon.affects?(burma)
    refute defcon.affects?(kenya)
  end

  FakeCountry = Struct.new(:regions)

end

