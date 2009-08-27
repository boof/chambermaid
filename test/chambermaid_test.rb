require 'test/unit'

require 'chambermaid'
require 'teaser'
require 'uri'

TeaserBrowser = Chambermaid.browser Teaser

TeaserInstance = Teaser.new 2,
  :content => 'Content',
  :headline => 'Headline',
  :url => URI.parse('http://www.github.com')

# TeaserBrowser.store obj
page = Chambermaid.write TeaserInstance, 'Ensure a test teaser exists.'

=begin
module Grit
  self.debug = true
  class Repo
    def self.init(path)
      ENV['GIT_WORK_TREE'] = path
      Grit::Git.new("#{ path }/.git").run '', :init, '', {}, []
      new path
    end
  end
end

Dir.open TeaserBrowser.location do |teasers_dir|
  teasers_dir.each do |filename|
    next if filename[0, 1].eql? '.'

    path = File.join 'teasers', filename
    next unless File.directory? path

    Grit::Repo.init(path).instance_eval do
      begin
        add '.'
        commit_index 'Make files available...'
        commit = commits('master', 1).first
        git.tag({}, 'Bookmark')
        git.branch({}, 'ChapterOne')
      rescue
        FileUtils.rm_rf File.join(path, '.git')
        raise $!
      end
    end unless File.exists? File.join(path, '.git')
  end
end
=end

class TestChambermaid < Test::Unit::TestCase

  def assert_attributes(obj, attrs)
    attrs.each { |attr, expect| assert_equal expect, obj.__send__(attr) }
  end
  def page(n, *args)
    diary = TeaserBrowser.diary n
    diary.page(*args)
  end
  def page_count(teaser)
    TeaserBrowser.find(teaser).pages.length
  end

  def test_chambermaid_keeps_browser
    assert_instance_of Chambermaid::Browser, TeaserBrowser
  end
  def test_browser_enumerates_over_diaries
    TeaserBrowser.diaries.each { |diary| assert Chambermaid::Diary === diary }
    TeaserBrowser.each_diary { |diary| assert Chambermaid::Diary === diary }
  end
  def test_diary_enumerates_over_pages
    diary = TeaserBrowser.diary 2
    diary.pages.each { |page| assert Chambermaid::Diary::Page === page }
    diary.each_page { |page| assert Chambermaid::Diary::Page === page }
  end

  def test_page_delegates_to_target
    assert_attributes page(2),
      :content => 'Content',
      :headline => 'Headline',
      :url => URI('http://slashdot.org/')
  end
  def test_page_builds_target
    teaser = page(2).target
    assert_instance_of Teaser, teaser
    assert_attributes teaser,
      :content => 'Content',
      :headline => 'Headline',
      :url => URI('http://slashdot.org/')
  end

  def test_missing_attribute_raises_name_error
    assert_raises(NoMethodError) { page(2).undefined }
  end
  def test_page_delegates_methods
    assert_nothing_raised { page(2).to_s }
  end

  def test_chambermaid_writes_pages
    teaser = page(2).target
    teaser.content = 'Another Content'

    expected_length = page_count(teaser) + 1
    page = Chambermaid.write teaser
    assert_equal expected_length, page_count(teaser)

    Chambermaid.write page.previous.target
  end

  def test_diary_has_chapters
    diary = TeaserBrowser.diary 2
    chapter = diary.page('ChapterOne')

    assert diary.chapters.values.include?(chapter)
    assert_equal diary.page, chapter
  end
  def test_diaries_chapter_are_branches
  end
  def test_diary_has_bookmarks
    diary = TeaserBrowser.diary(2)
    bookmark = diary.page('Bookmark')

    assert diary.bookmarks.values.include?(bookmark)
    assert_equal diary.page, bookmark
  end
  def test_diaries_bookmarks_are_tags
  end
  def test_teaser_creates_new_repository
    teaser = Teaser.new
    teaser.id = 1
    teaser.headline = 'Create a new repository!'
    teaser.url = URI 'http://www.git-scm.org'
    teaser.content = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

    assert_nil TeaserBrowser.find(teaser)
    page = Chambermaid.write teaser
    assert_instance_of Diary, TeaserBrowser.find(teaser)
  end

end
