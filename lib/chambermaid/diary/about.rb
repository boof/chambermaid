class Chambermaid::Diary::About
  autoload :Initializer, __FILE__.insert(-4, '/initializer')

  def initialize(subject, opts)
    @subject_name, @location = subject.name, opts[:in]
  end

  attr_reader :location, :attributes, :reader, :builder

  def subject
    Object.const_get @subject_name
  end

  def initializer
    @initializer ||= Initializer.new @attributes ||= {}
  end

  def attribute(attr)
    @attributes.fetch attr
  rescue IndexError
    raise NameError, "attribute #{ a } is not defined"
  end
  alias_method :[], :attribute

  def reading(attr)
    attribute(attr).reading
  end

end
