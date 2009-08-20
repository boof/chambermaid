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

Dir.open('teasers') do |teasers_dir|
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
  def page
    diary = TeaserBrowser.diary 2
    diary.current_page
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
    assert_attributes page,
      :content => 'Content',
      :headline => 'Headline',
      :url => URI('http://slashdot.org/')
  end
  def test_page_builds_target
    assert_attributes page.target,
      :content => 'Content',
      :headline => 'Headline',
      :url => URI('http://slashdot.org/')
  end
  def test_missing_attribute_raises_attribute_error
    assert_raises(NameError) { page.undefined }
  end

end
