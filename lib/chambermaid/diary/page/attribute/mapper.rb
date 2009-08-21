class Chambermaid::Diary::Page::Attribute

  class Mapper

    def initialize(draft, attribute)
      @draft, @attribute = draft, attribute
    end

    def reads(attribute, &reader)
      @draft.attributes[attribute] ||= Mapping.new @attribute
      @draft.attributes[attribute].reads &reader
    end

  end

  class Mapping

    def initialize(attribute)
      @attribute = attribute
    end

    def name
      @attribute.name
    end

    def reads(&reader)
      @reader = reader
    end

    def [](context)
      @reader.call @attribute[context]
    end

  end

end
