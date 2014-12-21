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

  def needs(target)
    target.class.respond_to?(:needs) ? target.class.needs : []
  end

  def inject(target, descend: true)
    failed = []

    needs(target).each do |attr|
      if @source.respond_to?(attr)
        source_attr = @source.send(attr)

        needs_raw = target.respond_to?(:needs_raw?) && target.needs_raw?

        if source_attr.respond_to?(:__value__) && !needs_raw
          target.send("#{attr}=", source_attr.__value__)
        else
          target.send("#{attr}=", source_attr)
        end
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

    descend(target) if descend
  end

  def descend(target)
    if target.class.respond_to?(:arguments)
      target.class.arguments.each do |arg|
        inject(target.send(arg), descend: false)
      end
    end
  end

  def inspect
    "<Injector with source %s>" % [@source]
  end

  InadequateSourceError = Class.new(RuntimeError)
end

class NullInjector < Injector
  def inject(target)
  end
end

