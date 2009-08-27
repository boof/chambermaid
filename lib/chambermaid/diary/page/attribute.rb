class Chambermaid::Diary::Page::Attribute
  autoload :Mapper, __FILE__.insert(-4, '/mapper')
  autoload :Filter, __FILE__.insert(-4, '/filter')
  autoload :Reading, __FILE__.insert(-4, '/reading')
  autoload :Writing, __FILE__.insert(-4, '/writing')

  attr_reader :name, :filters
  alias_method :to_s, :name

  def initialize(name, filters, args)
    @name, @args, @filters = name, args, filters
  end
  def read(context)
    context.value = context.name.split('.')[ 1.. -1 ].reverse.
        inject(nil) { |last, unit| Reading[ unit ][ context, last ] }
  end
  def write(context)
    delete context if blob and name_will_change? || value.nil?
    create context if value

    context.writing_units.
        inject(nil) { |last, unit| Writing[ unit ][ context, last ] }
  end

  def delete(context)
    raise NotImplementedError, "delete #{ name }"
  end
  def create(context)
    raise NotImplementedError, "create #{ name_from_value }"
  end

  def name_from_blob(context)
    context.blob.name
  end
  def name_from_value(context)
    filters = []

    return unless @filters.all? { |u|
      if not match = /:(.*)/.match(u)
        filters << u
      elsif context.value and match[1] == @name
        filters << context.value
      end
    }

    "#{ @name }.#{ filters * '.' }"
  end

end
