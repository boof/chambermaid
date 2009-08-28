class Chambermaid::Diary::About::Initializer
  Attribute = Chambermaid::Diary::Page::Attribute
  Mapper = Attribute::Mapper

  attr_reader :attributes, :blobs

  def initialize(accessors, blobs)
    @accessors, @blobs = accessors, blobs
  end
  def accessor(name, filters = 'txt')
    attribute = Attribute.new name, filters.split('.')
    @blobs << attribute
    @accessors[name] = attribute
  end
  def map(name, filters = 'yml')
    attribute = Attribute.new name, filters.split('.')
    @blobs << attribute
    yield Mapper.new(self, attribute)
  end

end
