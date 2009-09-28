require 'test_helper'

class TestExampleChambermaid < Test::Unit::TestCase
  include Helper::TestContext

  def assert_inclusion_of(expect, provide)
    assert provide.include?(expect), "#{ provide.inspect } does not include #{ expect.inspect }"
  end

  def test_browser_is_build
    assert_inclusion_of Chambermaid::Interfaces::Browser, Chambermaid::Browser['Example'].ancestors
    assert_equal 'Example', Chambermaid::Browser['Example'].name
  end
  def test_diary_is_build
    assert_inclusion_of Chambermaid::Interfaces::Diary, Chambermaid::Diary['Example'].ancestors
    assert_equal 'Example', Chambermaid::Diary['Example'].name
  end
  def test_chapter_is_build
    assert_inclusion_of Chambermaid::Interfaces::Chapter, Chambermaid::Chapter['Example'].ancestors
    assert_equal 'Example', Chambermaid::Chapter['Example'].name
  end
  def test_page_is_build
    assert_inclusion_of Chambermaid::Interfaces::Page, Chambermaid::Page['Example'].ancestors
    assert_equal 'Example', Chambermaid::Page['Example'].name
  end
  
end
