class Chambermaid::Diary::About::Initializer
  Attribute = Chambermaid::Diary::Page::Attribute
  Mapper = Attribute::Mapper

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end
  def attribute(name, filters = '', *args)
    @attributes[name] = Attribute.new name, filters.split('.'), args
  end
  def map(name, filters = '', *args)
    attr = Attribute.new name, filters.split('.'), args
    yield Mapper.new(self, attr)
  end

end
