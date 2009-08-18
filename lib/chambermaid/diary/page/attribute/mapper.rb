class Chambermaid::Diary::Page::Attribute

  class Mapper

    def initialize(draft, attribute)
      @draft, @attribute = draft, attribute
    end

    def reader(attribute, &reader)
      @draft.attributes[attribute] ||= Mapping.new @attribute
      @draft.attributes[attribute].reader &reader
    end

  end

  class Mapping

    def initialize(attribute)
      @attribute = attribute
    end

    def reader(&reader)
      @reader = reader
    end

    def [](context)
      @reader.call @attribute[context]
    end

    def filename
      @attribute.filename
    end

  end

end
