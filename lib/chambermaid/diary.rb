class Chambermaid::Diary
  autoload :About, __FILE__.insert(-4, '/about')
  autoload :Page, __FILE__.insert(-4, '/page')

  def initialize(about, repo)
    @about, @repo = about, repo
  end

  def current_page
    build_page 'master'
  end

  def each_page(*args)
    @repo.commits(*args).each { |commit| build_page commit.id }
  end
  def pages
    collection = []
    each_page { |page| collection << page }
    collection
  end

  protected

    def build_page(commit_id)
      Page.new @about, @repo.tree(commit_id)
    end

end
