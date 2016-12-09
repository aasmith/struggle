require "helper"

module ModifierTests
  class NatoTest < Struggle::Test

    def setup
      @mod = Modifiers::Permission::Nato.new
      @mod.events_in_effect = EventsInEffect.new

      @mod.countries = Countries.new([
        @de = country("West Germany",   region: Europe),
        @fr = country("France",         region: Europe),
        @uk = country("United Kingdom", region: Europe),
        @es = country("Spain/Portugal", region: Europe),
        @it = country("Italy",          region: Europe),
        @af = country("Afghanistan",    region: Asia)
      ])

      control @uk, player: US
      control @de, player: US
      control @fr, player: US
      control @af, player: US
      control @it, player: USSR
    end

    def test_protects_us_controlled_countries_in_europe
      ussr_cannot_tamper_in @uk
      ussr_cannot_tamper_in @de
      ussr_cannot_tamper_in @fr

      ussr_can_tamper_in @es
      ussr_can_tamper_in @it
      ussr_can_tamper_in @af
    end

    def test_france_unprotected_when_de_gaulle_in_effect
      elect_de_gaulle

      ussr_cannot_tamper_in @uk
      ussr_cannot_tamper_in @de

      ussr_can_tamper_in @fr
      ussr_can_tamper_in @es
      ussr_can_tamper_in @it
      ussr_can_tamper_in @af
    end

    def test_west_germany_unprotected_when_willy_brandt_in_effect
      elect_willy_brandt

      ussr_cannot_tamper_in @uk
      ussr_cannot_tamper_in @fr

      ussr_can_tamper_in @de
      ussr_can_tamper_in @es
      ussr_can_tamper_in @it
      ussr_can_tamper_in @af
    end

    def test_france_and_germany_unprotected_with_brandt_and_de_gaulle
      elect_willy_brandt
      elect_de_gaulle

      ussr_cannot_tamper_in @uk

      ussr_can_tamper_in @de
      ussr_can_tamper_in @fr
      ussr_can_tamper_in @es
      ussr_can_tamper_in @it
      ussr_can_tamper_in @af
    end

    def test_us_is_not_prevented_from_any_coups_or_realignments
      @mod.countries.each do |country|
        assert @mod.allows?(coup_in(country, player: US))
        assert @mod.allows?(realign_in(country, player: US))
      end
    end

    def country(name, region:)
      Country.new(name, 1, false, region, [])
    end

    def control(country, player:)
      country.add_influence(player, 2)
    end

    def ussr_can_tamper_in(country)
      assert @mod.allows?(coup_in(country, player: USSR))
      assert @mod.allows?(realign_in(country, player: USSR))
    end

    def ussr_cannot_tamper_in(country)
      refute @mod.allows?(coup_in(country, player: USSR))
      refute @mod.allows?(realign_in(country, player: USSR))
    end

    def coup_in(country, player:)
      Move.new(
        player: player,
        instruction: Instructions::Coup.new(
          player: player,
          country_name: country.name
        )
      )
    end

    def realign_in(country, player:)
      Move.new(
        player: player,
        instruction: Instructions::Realignment.new(
          player: player,
          country_name: country.name
        )
      )
    end

    def elect_de_gaulle
      @mod.events_in_effect.add "DeGaulleLeadsFrance"
    end

    def elect_willy_brandt
      @mod.events_in_effect.add "WillyBrandt"
    end
  end

end
