module Instructions

  class WarInvasion < Instruction

    fancy_accessor :country_name

    needs :countries, :die

    def initialize(country_name:)
      super

      self.country_name = country_name
    end

    def action
      victory = resolve_war(
               player: player,
         country_name: country_name,
        victory_range: victory_range,
      )

      Instructions::WarOutcomeFactory.build(
              player: player,
        country_name: country_name,
             victory: victory,
        military_ops: military_ops,
            vp_award: vp_award
      )
    end

    def military_ops
      raise NotImplementedError
    end

    def victory_range
      raise NotImplementedError
    end

    def vp_award
      raise NotImplementedError
    end

  end

end
