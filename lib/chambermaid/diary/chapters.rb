module Chambermaid
  class Diary
    class Chapters
      include Enumerable
      include Timestamped

      extend Forwardable
      def_delegators :@diary, :repository

      def initialize(diary, chapter_class)
        @diary, @chapter_class, @chapter_names = diary, chapter_class, []
      end

      def path
        File.join @diary.path, %w[ .git refs heads ]
      end
      def exists?(name)
        File.exists? File.join(path, name)
      end
      def new(name, opts = {})
        @chapter_class.new @diary, name, opts
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
        current_head = repository.head
        new current_head.name, :head => current_head
      end

      protected

        def rebuild_map
          repository.heads.inject([]) do |objects, head|
            yield new(head.name, :head => head)
            objects << head.name
          end
        end

    end
  end
end