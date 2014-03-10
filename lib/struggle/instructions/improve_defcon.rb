module Instructions
  class ImproveDefcon < Instruction

    fancy_accessor :amount

    needs :defcon

    def initialize(amount:)
      super

      self.amount = amount
    end

    def action
      defcon.improve(amount)
    end
  end
end
