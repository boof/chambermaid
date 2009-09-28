module Chambermaid::Collectors
  class Chapters
    include Enumerable
    include Chambermaid::Collectors::Timestamped

    def initialize(diary)
      @diary, @chapter_names = diary, []
    end

    def path
      File.join @diary.path, %w[ .git refs heads ]
    end
    def exists?(name)
      File.exists? File.join(path, name)
    end
    def new(name, opts = {})
      (@diary.class)::Chapter.new @diary, name, opts
    end
    def find(name)
      new name if exists? name
    end
    def each
      if fresh?
        @chapter_names.each { |name| yield new(name) }
      else
        @chapter_names = rebuild_map { |chapter| yield chapter }
        refresh
      end

      @chapter_names
    end

    def last(limit = 1)
      return [] if limit < 1

      chapters, index = [], 0
      each do |chapter|
        chapters << chapter
        index += 1
        break unless index < limit
      end

      ( limit == 1 )? chapters.first : chapters
    end
    def current
      current_head = @diary.repository.head
      new current_head.name, :head => current_head
    end

    protected

      def rebuild_map
        @diary.repository.heads.inject([]) do |objects, head|
          yield new(head.name, :head => head)
          objects << head.name
        end
      end

  end
end
