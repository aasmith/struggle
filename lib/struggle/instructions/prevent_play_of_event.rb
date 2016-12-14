module Instructions

  class PreventPlayOfEvent < Instruction

    fancy_accessor :card_ref, :reason

    needs :engine, :cards

    def initialize(card_ref:, reason:)
      self.card_ref = card_ref
      self.reason = reason
    end

    def action
      preventer = Modifiers::Permission::CardPlayEventPreventer.new(
        card_ref: card_ref,
          reason: reason
      )

      engine.add_permission_modifier(preventer)

      card = cards.find_by_ref card_ref

      log "Play of %s is now prevented." % card.name

    end
  end

end
