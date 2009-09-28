module Chambermaid::Types
  class TrueClass < Chambermaid::BlankSlate
    def self.name; 'TrueClass' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['true'] = name

    def __extname
      '.true'
    end

    def __serialize(integer)
      FileUtils.touch __path unless File.directory? __path
    end
    def __build
      true
    end

    include Chambermaid::Interfaces::Page
  end
end
