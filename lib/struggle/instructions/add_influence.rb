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
    arguments :influence, :amount, :country_name

    needs :countries

    def action
      countries.find(country_name).add_influence(influence, amount)
    end
  end
end
