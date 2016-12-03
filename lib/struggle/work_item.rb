class WorkItem
  extend Injectable

  def initialize(**args)
    @complete = false
  end

  def complete?() @complete end
  def incomplete?() !complete?() end

  private

  def complete
    @complete = true
  end
end

