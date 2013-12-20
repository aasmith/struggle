module Injectible
  def needs(*attrs)
    @needs ||= []
    @needs.push(*attrs)

    if attrs.empty?
      @needs
    else
      attr_accessor(*attrs)
    end
  end
end

class Injector
  def initialize(source)
    @source = source
  end

  def inject(target)
    failed = []

    target.class.needs.each do |attr|
      if @source.respond_to?(attr)
        target.send("#{attr}=", @source.send(attr))
      else
        failed << attr
      end
    end

    unless failed.empty?
      raise InadequateSourceError,
        "Source %s failed to provide variables %s for target %s" % [
          @source, failed.join(',').inspect, target
        ]
    end
  end

  InadequateSourceError = Class.new(RuntimeError)
end

