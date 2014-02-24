##
# Removes influence markers from a country, no questions asked.
#
# +Amount+ refers to the number of markers to be removed.
#
# Requires the Countries registry.
#
module Instructions
  class RemoveInfluence < Instruction
    fancy_accessor :influence, :amount, :country_name

    needs :countries

    def initialize(influence:, amount:, country_name:)
      super

      self.influence = influence
      self.amount = amount
      self.country_name = country_name
    end

    def action
      countries.find(country_name).remove_influence(influence, amount)
    end
  end
end
