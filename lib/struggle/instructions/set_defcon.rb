module Instructions
  class SetDefcon < Instruction

    fancy_accessor :amount

    needs :defcon

    def initialize(amount:)
      super

      self.amount = amount
    end

    def action
      defcon.set(amount)
    end
  end
end
