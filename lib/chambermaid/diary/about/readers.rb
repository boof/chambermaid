class Chambermaid::Diary::About

  class Reader # < AbstractReader
    Page = Chambermaid::Diary::Page

    def initialize(about)
      @about = about
    end

    def each
      each_directory { |path| yield build_page(path) }
    end

    protected
      def each_directory(location = @about.location)
        Dir.open location do |dir|
          while entry = dir.read
            next if entry[0, 1] == '.'
            path = File.join location, entry
            yield path if File.directory? path
          end
        end
      end
      def build_page(path)
        Page.new @about, path
      end

  end

  class CachedReader < Reader

    def initialize(about)
      @cached_paths, @cached_at = [], nil
      super
    end

    protected
      def each
        unless cache_valid?
          @cached_paths.clear
          each_directory { |path| @cached_paths << path }
        end

        @cached_paths.each { |path| yield build_page(path) }
      end
      def cache_valid?
        File.mtime(@location) == @cached_at
      end

  end
end
