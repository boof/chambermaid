class Chambermaid::Diary
  autoload :About, __FILE__.insert(-4, '/about')
  autoload :Page, __FILE__.insert(-4, '/page')

  def initialize(about, repo)
    @about, @repo = about, repo
  end

  def page(n)
    Page.new @about, @repo.tree(n)
  end
  def last_page
    page 'master'
  end
  alias_method :master, :last_page

  def find_chapter_by_name(name)
    name = name.to_s
    head = @repo.heads.find { |h| h.name == name }
    head.commit.id if head
  end

  def method_missing(chapter_name)
    n = find_chapter_by_name chapter_name
    return super unless n

    page n
  end

  def each_page(*args)
    @repo.commits(*args).each { |commit| page commit.id }
  end
  def pages
    collection = []
    each_page { |page| collection << page }
    collection
  end

end
