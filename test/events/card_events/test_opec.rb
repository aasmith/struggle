require "helper"

module CardEventTests
  class OpecTest < Struggle::Test

    def test_nothing_happens_when_north_sea_oil_in_effect
      event = Events::CardEvents::Opec.new
      event.events_in_effect = EventsInEffect.new(["NorthSeaOil"])

      instructions = event.execute

      assert_equal [Instructions::Discard], instructions.map(&:class)
    end

    def test_vp_award

      country_list = generate_countries(
        "Egypt", "Iran", "Libya", "Saudi Arabia",
        "Iraq", "Gulf States", "Venezuela"
      )

      countries = Countries.new(country_list)
      countries.find("Libya").add_influence(USSR, 5)
      countries.find("Iran").add_influence(USSR, 5)
      countries.find("Iraq").add_influence(USSR, 5)

      event = Events::CardEvents::Opec.new
      event.events_in_effect = EventsInEffect.new()
      event.countries = countries

      instructions = event.execute

      assert_equal [Instructions::AwardVictoryPoints, Instructions::Discard],
        instructions.map(&:class)

      award, _ = instructions

      assert_equal USSR, award.player
      assert_equal 3, award.amount
    end

  end
end

