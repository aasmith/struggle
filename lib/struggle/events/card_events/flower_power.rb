module Events
  module CardEvents

    class FlowerPower < Instruction

      needs :countries

      def action
        instructions = []

        # do nothing if evil empire in effect

        instructions << Instructions::Noop.new(label: "something")
        instructions << Instructions::Noop.new(label: "in effect")
        instructions << Instructions::Noop.new(label: "dump the card")

        instructions
      end

    end

  end
end
