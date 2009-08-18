class Chambermaid::Diary::Page::Attribute
  autoload :Mapper, __FILE__.insert(-4, '/mapper')
  autoload :Filter, __FILE__.insert(-4, '/filter')
  autoload :Reading, __FILE__.insert(-4, '/reading')
  autoload :Writing, __FILE__.insert(-4, '/writing')

  attr_reader :reading, :writing

  def initialize(name, filters, options)
    @name, @options, self.filters = name, options, filters
  end
  def filename
    fn, regexp = [ @name ], false

    fn += @writing.map do |filter|
      filter.sub(/:[A-Za-z0-9_]+/) do |s|
        regexp = true
        @options.fetch s[ 1.. -1 ].to_sym, '.+'
      end
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
