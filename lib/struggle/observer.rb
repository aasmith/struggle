
# A module for observing things. An observer can be (de)activated, allowing
# the upstream notifier to direct observations as needed.
#
# Terminators provide another way to deactivate an observer. By populating
# +terminators+ with one or more +Matcher+s, the observer will be deactivated
# any time an item is observed and matched by any of the matchers.

module Observer

  attr_accessor :observation_terminators

  alias terminators observation_terminators

  def deactivate
    @active = false
  end

  def activate
    @active = true
  end

  def active?
    @active
  end

  def notify(item)
    deactivate if terminators.any? { |matcher| matcher.matches?(item) }
    observed item
  end

  # Implement in subclasses
  def observed(item)
  end

end

