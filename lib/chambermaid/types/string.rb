module Chambermaid::Types
  class String < Chambermaid::BlankSlate
    def self.name; 'String' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['txt'] = name

    def __extname; '.txt' end

    def __serialize(string)
      File.open(__path, 'w') { |io| io << string }
    end
    def __build
      __tree_object.data
    end

    include Chambermaid::Interfaces::Page
  end
end
