module Chambermaid
  class Diary
    class Chapter
      class Pages
        include Enumerable
        include Timestamped
        extend Forwardable
        def_delegators :@chapter, :repository, :decorate, :name, :path

        def initialize(chapter, page_class)
          @chapter, @page_class, @pages = chapter, page_class, []
        end

        def create(object, message = object.inspect)
          page = new :object => object
          page.write

          repository.commit_index message
        end

        def new(opts = {})
          opts[:tree_object] ||= @chapter.tree
          @page_class.root @chapter, opts
        end
        def each
          if fresh?
            @pages.each { |treeish| yield get(treeish) }
          else
            @pages = rebuild_map { |page| yield page } and refresh
          end
        end

        def first(n = 1)
          raise NotImplementedError
        end
        def last(limit = 1)
          return if limit < 1

          pages, index = [], 0
          each do |page|
            pages << page
            index += 1
            break unless index < limit
          end

          ( limit == 1 )? pages.first : pages
        end
        alias_method :current, :last

        protected

          def rebuild_map(limit = false)
            repository.commits(name, limit).reverse.
                inject([]) do |treeishs, commit|
                  yield new
                  treeishs << treeish
                end
          end

      end
    end
  end
end
