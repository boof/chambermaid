module Chambermaid::Collectors
  class Pages
    include Enumerable
    include Chambermaid::Collectors::Timestamped

    def path
      @chapter.path
    end

    def initialize(chapter)
      @chapter, @pages = chapter, []
    end

    def create(object, message = object.inspect)
      page = new :object => object
      old_commit = @chapter.head.commit
      page.write

      @chapter.repository.add '.'
      @chapter.repository.commit_index message
      new_commit = @chapter.repository.head.commit
      page.__context.commit = @chapter.repository.head.commit
      page.__context.tree = @chapter.tree

      page
    end

    def new(attrs = {})
      # TODO: unstub me...
      context = OpenStruct.new
      context.references = Chambermaid::References.new context
      context.repository = @chapter.diary.repository
      context.path = @chapter.diary.path
      context.head_name = @chapter.name
      context.commit = @chapter.head.commit
      context.tree = @chapter.tree

      (@chapter.class)::Frontpage.new context, attrs
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
        @chapter.repository.commits(@chapter.name, limit).reverse.
            inject([]) do |treeishs, commit|
              yield new
              treeishs << treeish
            end
      end

  end
end
