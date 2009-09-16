require 'test_helper'

class TestChambermaid < Test::Unit::TestCase
  include Helper::TestContext

  class Inherited < String; end

  def test_lookup_for_unknown_class_names
    browser_class = Chambermaid::BROWSERS[ Inherited.name ]
    assert 'Chambermaid::StringBrowser', browser_class.name
  end
  def test_browser_is_build
    browser_class = Chambermaid::BROWSERS[ Example.name ]
    assert_equal 'Chambermaid::ExampleBrowser', browser_class.name
  end
  def test_diary_is_build
    diary_class = Chambermaid::DIARIES[ Example.name ]
    assert_equal 'Chambermaid::ExampleDiary', diary_class.name
  end
  def test_chapter_is_build
    chapter_class = Chambermaid::CHAPTERS[ Example.name ]
    assert_equal 'Chambermaid::ExampleChapter', chapter_class.name
  end
  def test_page_is_build
    page_class = Chambermaid::PAGES[ Example.name ]
    assert_equal 'Chambermaid::ExamplePage', page_class.name
  end
  
end
