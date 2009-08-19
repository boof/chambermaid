require 'test/unit'
require 'fileutils'
require 'chambermaid'
require 'teaser'

TeaserDiary = Chambermaid.diary Teaser

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

Grit::Repo.init('teasers/0').instance_eval do
  add '.'
  commit_index 'Make files available...'
end unless File.exists? 'teasers/0/.git'

class TestChambermaid < Test::Unit::TestCase

  def assert_attributes(obj, attrs)
    attrs.each { |attr, expect| assert_equal expect, obj.__send__(attr) }
  end
  def page
    TeaserDiary.find { |page| page.id == 2 }
  end

  def test_chambermaid_keeps_diary
    assert_instance_of Chambermaid::Diary, TeaserDiary
  end
  def test_diary_enumerates_over_pages
    TeaserDiary.each { |page| assert Chambermaid::Diary::Page === page }
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

end
