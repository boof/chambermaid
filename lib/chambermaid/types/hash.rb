module Chambermaid::Types
  class Hash < Chambermaid::BlankSlate
    def self.name; 'Hash' end
    Chambermaid::Page[name] = self
    Chambermaid::EXTNAME_TO_CLASSNAME['hash'] = name

    def __extname; '.hash' end

    def __serialize(hash)
      FileUtils.mkdir_p __path unless File.directory? __path
      path_gitignore = File.join __path, '.gitignore'
      FileUtils.touch path_gitignore unless File.exists? path_gitignore

      hash.each { |key, value| set(key, value).write }
    end
    def __build
      objects = {}
      each do |c|
        key = c.__tree_object.name[/^[^\.]+/]
        objects[ key ] = c.read
      end

      objects
    end

    def each
      __tree_object.contents.each do |tree_object|
        unless tree_object.name == '.gitignore'
          yield tree_object.name, get(tree_object.name, tree_object)
        end
      end
    end

    include Chambermaid::Interfaces::Page
  end
end
