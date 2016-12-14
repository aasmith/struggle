module Instructions

  class AllowPlayOfEvent < Instruction

    fancy_accessor :card_ref

    needs :engine, :cards

    def initialize(card_ref:)
      self.card_ref = card_ref
    end

    def action
      preventer = engine.permission_modifiers.detect do |mod|
        Modifiers::Permission::CardPlayEventPreventer === mod &&
          mod.card_ref == card_ref
      end

      if preventer
        engine.remove_permission_modifier(preventer)

        card = cards.find_by_ref card_ref

        log "Play of %s is now allowed." % card.name
      end

    end
  end

end
