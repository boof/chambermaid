class Chambermaid::Diary::About
  Context = Chambermaid::Diary::Page::Context
  autoload :Initializer, __FILE__.insert(-4, '/initializer')

  def initialize(subject, opts)
    @subject_name, @accessors = subject.name, {}
    @as = opts.fetch :as
    @location, @reader = opts[:in], opts[:reader] || proc { |about, tree|
      obj = about.subject.new
      about.accessors.
          each { |n, rw| obj.send "#{ n }=", Context.new(rw, tree).value }
      obj
    }
  end

  attr_reader :location, :as, :accessors

  def subject
    Object.const_get @subject_name
  end

  def initializer
    Initializer.new @accessors
  end

  def attribute(attr)
    @accessors[ attr.to_sym ]
  end
  alias_method :[], :attribute

end
