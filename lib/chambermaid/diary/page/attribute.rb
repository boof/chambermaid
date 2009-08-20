class Chambermaid::Diary::Page::Attribute
  autoload :Mapper, __FILE__.insert(-4, '/mapper')
  autoload :Filter, __FILE__.insert(-4, '/filter')
  autoload :Reading, __FILE__.insert(-4, '/reading')
  autoload :Writing, __FILE__.insert(-4, '/writing')

  attr_reader :reading, :writing

  def initialize(name, filters, args)
    @name, @args, self.filters = name, args, filters
  end
  def filename
    fn, regexp = [ @name ], nil

    fn += @writing.map do |filter|
      # TODO: add support for non-Integer values
      filter.sub('%i') { |s| regexp = '\d+' }
    end

    regexp ? /#{ fn * '\\.' }/ : fn.join('.')
  end
  def [](context)
    context.reading_units.
        inject(nil) { |last, unit| Reading[ unit ][ context, last ] }
  end

  protected

    def filters=(filters)
      @reading, @writing = filters.reverse, filters
    end

end
