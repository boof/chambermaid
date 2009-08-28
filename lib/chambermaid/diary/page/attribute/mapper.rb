class Chambermaid::Diary::Page::Attribute

  class Mapper

    def initialize(draft, attribute)
      @draft, @attribute = draft, attribute
    end

    def accessor(attribute, blocks = {})
      @draft.accessors[attribute] = Mapping.new @attribute, blocks
    end

  end

  class Mapping

    def initialize(attribute, blocks)
      @attribute = attribute
      @reader = blocks[:reader] ||
          proc { |mapped| mapped[ @attribute.name ] }
      @writer = blocks[:writer] ||
          proc { |mapped| mapped[ @attribute.name ] = }
    end

    def name
      @attribute.name
    end

    def deserialize(context)
      @reader.call @attribute.deserialize(context)
    end
    def serialize(context)
      @writer.call
    end

  end

end
