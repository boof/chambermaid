class Chambermaid::Diary::About::Initializer
  Attribute = Chambermaid::Diary::Page::Attribute
  Mapper = Attribute::Mapper

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end
  def attribute(name, filters = '', options = {})
    @attributes[name] = Attribute.new name, filters.split('.'), options
  end
  def map(name, filters = '', options = {})
    attr = Attribute.new name, filters.split('.'), options
    yield Mapper.new(self, attr)
  end

end
