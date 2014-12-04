class Card
  attr_reader :ref, :id, :name, :phase, :side
  attr_reader :remove_after_event, :display_after_event,
              :always_evaluate_first, :prevent_in_headline

  def initialize(**args)
    args.each { |k,v| instance_variable_set("@#{k}", v) }
  end

  def scoring?
    ops.zero?
  end

  def early?
    phase == :early
  end

  def inspect
    star = remove_after_event ? "*" : ""
    underline = display_after_event ? "\u0332" : ""

    name = self.name.each_char.map { |c| "#{c}#{underline}" }.join

    "%3s: [%s %4s %-5s] %s%s" % [
      id, @ops, side || '-', phase.to_s.upcase,
      name, star
    ]
  end

  # Make the getting of ops a special condition. Card ops should be
  # determined / tracked using an OpsCounter.
  #
  # The easiest way to get one is to call Card#ops_counter.

  def ops!
    @ops
  end

  def ops_counter(ops_modifiers = [])
    OpsCounter.new(@ops, ops_modifiers)
  end

  def china_card?
    ref == "TheChinaCard"
  end

  def contains_event?
    !china_card?
  end
end

