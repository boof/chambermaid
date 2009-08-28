class Chambermaid::Diary::Page::Attribute
  autoload :Mapper, __FILE__.insert(-4, '/mapper')
  autoload :Filter, __FILE__.insert(-4, '/filter')
  autoload :Reading, __FILE__.insert(-4, '/reading')
  autoload :Writing, __FILE__.insert(-4, '/writing')

  attr_reader :name, :filters
  alias_method :to_s, :name

  def initialize(name, filters)
    @name, @filters = name, filters
  end
  def deserialize(context)
    applied_filters = blob_name(context).split('.')[ 1.. -1 ].reverse
    context.value = applied_filters.
        inject(nil) { |last, unit| Reading[ unit ][ context, last ] }
  end
  def serialize(context)
    old_name = blob_name context
    new_name = generate_name context

    context.repo.remove old_name if old_name != new_name
    return unless context.value

    path = File.join context.repo.working_dir, new_name
    File.open path, 'w' do |file|
      file << filters.inject(context.value) { |last, unit|
        Writing[ unit ][ context, last ] }
    end
    context.repo.add new_name
  end

  def delete(old_name)
    raise NotImplementedError, "delete #{ old_name }"
  end

  def blob_name(context)
    context.blob.name if context.blob
  end
  def generate_name(context)
    filters = []

    return false unless @filters.all? { |u|
      if not match = /%/.match(u)
        filters << u
      elsif context.value
        filters << context.value
      else
        raise NameError, 'variable name expects value'
      end
    }

    "#{ @name }.#{ filters * '.' }"
  end

end
