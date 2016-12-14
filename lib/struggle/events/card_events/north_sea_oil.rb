module Events
  module CardEvents

    class NorthSeaOil < Instruction

      needs :countries

      def action
        instructions = []

        # TODO: prevent play of OPEC

        instructions << Instructions::Noop.new(label: "something")
        instructions << Instructions::Noop.new(label: "dump the card")

        instructions
      end

    end

  end
end
