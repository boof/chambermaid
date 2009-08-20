class Chambermaid::Diary::About
  Context = Chambermaid::Diary::Page::Context
  autoload :Initializer, __FILE__.insert(-4, '/initializer')

  def initialize(subject, opts)
    @subject_name, @attributes = subject.name, {}
    @location, @builder = opts[:in], opts[:builder] || proc { |about, tree|
      obj = about.subject.new
      about.attributes.
          each { |n, attr| obj.send "#{ n }=", Context.new(attr, tree).value }
      obj
    }
  end

  attr_reader :location, :attributes, :builder

  def subject
    Object.const_get @subject_name
  end

  def initializer
    @initializer ||= Initializer.new @attributes
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
