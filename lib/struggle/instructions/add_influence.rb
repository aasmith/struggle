##
# Adds influence markers to a country, no questions asked.
#
# +Amount+ refers to the number of markers to be placed, not the amount
# of points to be spent.
#
# Requires the Countries registry.
#
module Instructions
  class AddInfluence < Instruction
    fancy_accessor :influence, :amount, :country_name

    needs :countries

    def initialize(influence:, amount:, country_name:)
      super

      self.influence = influence
      self.amount = amount
      self.country_name = country_name
    end

    def action
      country = countries.find(country_name)
      country.add_influence(influence, amount)

      log "%s %4s influence added -> %s" % [
        amount, influence, country
      ]
    end
  end
end
