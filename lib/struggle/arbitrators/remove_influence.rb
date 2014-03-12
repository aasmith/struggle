module Arbitrators

  class RemoveInfluence < ChangeInfluence

    needs :countries

    def after_execute(move)
      super

      complete if all_possible_influence_removed?
    end

    def accepts?(move)
      Instructions::RemoveInfluence === move.instruction && super
    end

    def all_possible_influence_removed?
      if total_countries
        # If all countries that can be touched have been,
        # and all of those countries have been maxed out,
        # then all possible influence has been removed.
        affected_countries.size == total_countries &&
          (affected_countries - maxed_countries(affected_countries)).empty?

      else
        (country_names - maxed_countries(country_names)).empty?
      end
    end

    # List of country names where influence can no longer be removed
    #
    # (either max influence removed, or is zero)

    def maxed_countries(country_names)
      maxed = []

      country_names.each do |country_name|
        if maximum_influence_removed_from_country?(country_name) ||
               all_influence_removed_from_country?(country_name)

          maxed << country_name

        end
      end

      maxed
    end

    def maximum_influence_removed_from_country?(country_name)
      @country_count[country_name] == limit_per_country
    end

    def all_influence_removed_from_country?(country_name)
      country = countries.find(country_name)

      country.influence(influence).zero?
    end

  end

end
