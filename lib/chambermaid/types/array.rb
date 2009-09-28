module Chambermaid::Types
  class Array < Chambermaid::BlankSlate
    def self.name; 'Array' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['array'] = name
  
    def __extname; '.array' end

    def __serialize(array)
      FileUtils.mkdir_p __path unless File.directory? __path
      path_gitignore = File.join __path, '.gitignore'
      FileUtils.touch path_gitignore unless File.exists? path_gitignore

      index = 0
      array.each do |value|
        set(index, value).write
        index += 1
      end
    end
    def __build
      objects = []
      each do |c|
        index = Integer c.__tree_object.name[/^\d+/]
        objects[ index ] = c.read
      end

      objects
    end

    def each
      __tree_object.contents.each do |tree_object|
        unless tree_object.name == '.gitignore'
          index = Integer tree_object.name
          yield get(index, tree_object)
        end
      end
    end

    include Chambermaid::Interfaces::Page
  end
end
