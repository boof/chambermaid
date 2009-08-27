class Chambermaid::Diary
  autoload :About, __FILE__.insert(-4, '/about')
  autoload :Page, __FILE__.insert(-4, '/page')

  attr_reader :pages, :bookmarks, :chapters

  def initialize(about, repo)
    @pages      = Pages.new repo, about
    @chapters   = Chapters.new repo
    @bookmarks  = Bookmarks.new repo
  end

  def bookmark(page, name)
    bookmarks[name] = page
  end

  def page(n = 'HEAD')
    pages.get n.to_s
  end
  def method_missing(name, *args, &block)
    pages.get(name) or super
  end

  class AbstractCollection


    def initialize(repo)
      @repo, @objects, @mtime = repo, nil, Time.now
    end

    def each(*args)
      if args.empty? and up_to_date?
        @objects.each { |object| yield object }
      else
        @objects = rebuild_each(*args) { |object| yield object }
        up_to_date!
      end
    end
    include Enumerable

    protected

      def up_to_date?
        @objects and File.mtime(@repo.path) > @mtime
      end
      def invalidate!
        @objects = nil
      end
      def up_to_date!
        raise RuntimeError unless @object
        @mtime = File.mtime(@repo.path)
      end

      def rebuild_each(*args)
        raise NotImplementedError
      end

  end

  class Pages < AbstractCollection

    def initialize(repo, about)
      super(repo) and @about = about
    end

    def get(commit_id)
      Page.new @about, @repo.tree(commit_id)
    end

    def each(*args)
      super(*args) { |id| yield get(id) }
    end

    def last(n = 1)
      (n == 1) ? get('HEAD') : entries.last(n)
    end

    def <<(page)
      head = @repo.head
      @repo.checkout page.sha1

      @about.attributes.each do |name, attribute|
        page.__send__
      end
      # checkout tree
      @tree.checkout

      # write object values to repo
      @about.writer.call
      # commit written files
      # read page from commit id

      commit = @repo.head.in_branch(message) do
        @about.attributes.each do |name, attribute|
          attribute.serialize object => @repo
          @repo.add attribute.path
        end
      end and @objects = nil

      read commit.id

      invalidate!
    end

    def put(object, message = object.inspect, commit_id = 'HEAD')
      self << Page.new(@about, @repo.tree(commit_id), object)
      last
    end

    protected

      def rebuild_each(start = 'master', max_count = false, skip = 0)
        @repo.commits(start, max_count, skip).reverse.
            inject([]) do |objects, commit|
              yield id = commit.id
              objects << id
            end
      end

  end

  class Chapters < AbstractCollection

    protected

      def rebuild_each
        @repo.heads.inject([]) do |objects, head|
          yield name = head.name
          objects << name
        end
      end

  end

  class Bookmarks < AbstractCollection

    def []=(name, startpoint)
      @repo.add_tag name, case startpoint
          when Page; startpoint.__instance_variable_get(:@tree).id
          when String; startpoint
          else raise ArgumentError
          end
      invalidate!
    end

    protected

      def rebuild_each
        @repo.tags.inject([]) do |objects, tag|
          yield name = tag.name
          objects << name
        end
      end

  end

end

