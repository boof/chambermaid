module Chambermaid::Interfaces
  module Diary
    include Grit

    extend Forwardable
    def_delegators :@repository, :tree
    attr_reader :chapters, :path

    def initialize(path)
      # TODO: this should work a little bit more like a page
      @path = path
      initialize_repository

      @chapters = Chambermaid::Collectors::Chapters.new self
    end

    # Returns true if this diary is new. I.g. this means that the
    # 'master'-branch is to be born.
    def new?
      master_path = File.join @path, %w[ .git refs heads master ]
      not File.exists? master_path
    end

    # Returns chapter with given <tt>name</tt>.
    def chapter(name)
      @chapters.find name
    end

    # Returns instance of Pages for current HEAD.
    def pages
      @chapters.current.pages
    end

    # Sets the current page. This also resets the index and sets HEAD to
    # <tt>name</p>.
    def current=(treeish)
      @repository.git.reset treeish
    end
    # Returns the current page.
    def current
      pages.current
    end

    def repository
      @repository ||= Repo.new @path
    end

    protected

      def initialize_directory
        FileUtils.mkdir_p @path unless File.directory? @path
        initialize_git
      end
      def initialize_git
        path = File.join @path, '.git'
        Chambermaid::GitDir.create path unless File.directory? path
      end
      def initialize_repository
        initialize_directory
        initialize_git
      end

  end
end
