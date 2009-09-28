module Chambermaid::Types
  class Object < Chambermaid::BlankSlate
    def self.name; 'Object' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['yml'] = name

    def __extname; '.yml' end

    def __serialize(object)
      File.open(__path, 'w') { |io| YAML.dump object, io }
    end
    def __build
      YAML.parse __tree_object.data
    end

    include Chambermaid::Interfaces::Page
  end
end
