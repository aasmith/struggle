require "helper"

module CardEventTests
  class SoutheastAsiaScoringTest < Struggle::Test

    def test_awards_vp
      countries = Countries.new(generate_countries(
        "Burma", "Laos/Cambodia", "Vietnam", "Malaysia", "Indonesia",
        "Philippines", "Thailand"
      ))

      countries.find("Thailand").     add_influence(US,   5)
      countries.find("Vietnam").      add_influence(US,   5)
      countries.find("Laos/Cambodia").add_influence(USSR, 5)
      countries.find("Indonesia").    add_influence(USSR, 5)

      event = Events::CardEvents::SoutheastAsiaScoring.new
      event.countries = countries

      award, _remove = event.execute

      assert_instance_of Instructions::AwardNetVictoryPoints, award
      assert_equal 3, award.points_for(US)
      assert_equal 2, award.points_for(USSR)
    end

  end
end
