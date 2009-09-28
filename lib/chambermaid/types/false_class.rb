module Chambermaid::Types
  class FalseClass < Chambermaid::BlankSlate
    def self.name; 'FalseClass' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['false'] = name

    def __extname
      '.false'
    end

    def __serialize(integer)
      FileUtils.touch __path unless File.exists? __path
    end
    def __build
      false
    end

    include Chambermaid::Interfaces::Page
  end
end
