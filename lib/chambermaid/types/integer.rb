module Chambermaid::Types
  class Integer < Chambermaid::BlankSlate
    def self.name; 'Integer' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME.default = name

    def __extname
      ".#{ @object }"
    end

    def __serialize(integer)
      FileUtils.touch __path unless File.directory? __path
    end
    def __build
      Integer __tree_object.name[/\d+$/]
    end

    include Chambermaid::Interfaces::Page
  end
end
