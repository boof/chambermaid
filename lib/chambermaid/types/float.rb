module Chambermaid::Types
  class Precision < Chambermaid::BlankSlate
    def self.name; 'Float' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['float'] = name

    def __extname; '.float' end

    def __serialize(string)
      File.open(__path, 'w') { |io| io << string }
    end
    def __build
      Float __tree_object.data
    end

    include Chambermaid::Interfaces::Page
  end
end
