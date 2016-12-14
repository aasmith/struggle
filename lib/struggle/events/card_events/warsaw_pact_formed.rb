module Events
  module CardEvents

    class WarsawPactFormed < Instruction

      needs :countries

      def action
        instructions = []

        # TODO - allow play of nato, see MarshallPlan
        instructions << Instructions::Noop.new(label: "something")
        instructions << Instructions::Noop.new(label: "dump the card")

        instructions
      end

    end

  end
end
