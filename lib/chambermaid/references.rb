module Chambermaid
  class References
    include Enumerable

    def initialize(context)
      @context = context
    end
    def each
      values.each { |k, v| yield k[/^submodule "(.+)"$/, 1], v }
    end

    def [](name)
      values[%Q'submodule "#{ name }"']
    end
    def []=(name, context)
      values[%Q'submodule "#{ name }"'] = {
        'path' => name,
        'url' => context.path
      }
      # and there
      # .git/observer.yml with:
      # context.observer << @context
    end

    def dump
      gitmodules_path = File.join @context.path, '.gitmodules'
      File.open(gitmodules_path, 'w') { |file| IniFile.dump values, file }

      # TODO: copy files...
    end

    protected

      def load
        if blob = @context.tree / '.gitmodules'
          @values = IniFile.parse blob.data, :cchr => '#'
        else
          @values = {}
        end
      end
      def values
        load unless defined? @values
        @values
      end

  end
end
