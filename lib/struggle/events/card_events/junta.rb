module Events
  module CardEvents

    class Junta < Instruction

      needs :countries

      def action
        instructions = []

        instructions << Instructions::Noop.new(label: "something")
        instructions << Instructions::Noop.new(label: "dump the card")

        instructions
      end

    end

  end
end
