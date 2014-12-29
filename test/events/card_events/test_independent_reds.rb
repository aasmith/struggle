require "helper"

module CardEventTests
  class IndependentRedsTest < Struggle::Test

    def setup
      @countries = Countries.new(
        generate_countries(
          *Events::CardEvents::IndependentReds::COUNTRY_NAMES
        )
      )

      @event = Events::CardEvents::IndependentReds.new
      @event.countries = @countries
    end

    def test_nothing_to_do_when_ussr_leads_nowhere
      # All countries will be either zero, equal, or US leading.
      equalize
      us_lead

      instructions = @event.action

      assert_equal [Instructions::Remove], instructions.map(&:class)
    end

    def test_something_to_do_where_ussr_leads
      equalize
      us_lead
      ussr_lead

      instructions = @event.action

      assert_equal [Arbitrators::Proxy, Instructions::Remove],
        instructions.map(&:class)

      proxy, * = instructions
      choices  = proxy.choices

      # Only places where USSR leads should have arbitrators

      assert_equal [%w(Bulgaria), %w(Czechoslovakia)],
        choices.map(&:country_names)

      assert_equal [1, 1], choices.map(&:total_influence)
    end

    def equalize
      @countries.find("Romania").add_influence(USSR, 1)
      @countries.find("Romania").add_influence(US,   1)
    end

    def us_lead
      @countries.find("Hungary").add_influence(US, 1)
    end

    def ussr_lead
      @countries.find("Czechoslovakia").add_influence(USSR, 1)
      @countries.find("Bulgaria").add_influence(USSR, 1)
    end

  end
end
