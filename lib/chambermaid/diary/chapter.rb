module Chambermaid
  class Diary
    class Chapter
      extend Forwardable
      def_delegators :@diary, :serializer, :chapters

      attr_reader :pages, :diary, :name

      def initialize(diary, name, opts = {})
        @diary, @name, @head = diary, name, opts[:head]
        @head = new_branch opts[:treeish] unless branch_exists? or no_commits?

        @pages = Pages.new self, PAGES[CLASSNAME]
      end

      def head
        @head ||= @diary.repository.heads.find { |h| h.name == @name }
      end
      def path
        File.join @diary.repository.path, %w[ refs heads ], @name
      end

      def derivate(name)
        self.class.new @diary, name, :treeish => head.commit.id
      end

      def repository
        @diary.repository
      end
      def tree(treeish = @name, paths = [])
        @diary.tree treeish, paths
      end

      def inspect
        "#{ @diary.repository.working_dir }"
      end

      protected

        def branch_exists?
          chapters.exists? @name
        end
        def no_commits?
          @diary.new?
        end
        def needs_checkout?
          head != @diary.repository.head
        end
        def new_branch(treeish)
          @diary.repository.branch @name, treeish || 'master'
        end

    end
  end

  Chapter = Diary::Chapter
end
