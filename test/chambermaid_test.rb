require 'test/unit'
require 'fileutils'
require 'chambermaid'
require 'teaser'

TeaserBrowser = Chambermaid.browser Teaser

module Grit
  #self.debug = true
  Git.git_binary = '/opt/local/bin/git'
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
      add '.'
      commit_index 'Make files available...'
    end unless File.exists? File.join(path, '.git')
  end
end

class TestChambermaid < Test::Unit::TestCase

  def assert_attributes(obj, attrs)
    attrs.each { |attr, expect| assert_equal expect, obj.__send__(attr) }
  end
  def page(diary, n = nil)
    diary = TeaserBrowser.diary diary
    n ? diary.page(n) : diary.last_page
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
    assert_raises(NameError) { page(2).undefined }
  end

  def test_teaser_creates_new_page
    teaser = page(2).target
    teaser.headline = 'Another Headline'

    Chambermaid.write teaser
  end

  def test_teaser_creates_new_repository
    teaser = Teaser.new
    teaser.id = 1
    teaser.headline = 'Create a new repository!'
    teaser.url = URI 'http://www.git-scm.org'
    teaser.content = <<-DOC
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    DOC

    Chambermaid.write teaser
  end

end
