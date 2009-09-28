require 'test_helper'

class TestExampleDiary < Test::Unit::TestCase
  include Helper::TestContext

  def browser
    Chambermaid.browser Example
  end

  def test_attr_reader_returns_pages
    write_example do |example, page|
      diary = browser[example.id]
      page = diary.current

      assert Chambermaid::Types::Integer, page.id.class
      assert Chambermaid::Types::String, page.name.class
      assert Chambermaid::Types::Array, page.children.class
    end
  end
  def test_page_collects_garbage
    write_example do |example, page|
      diary = browser[example.id]
      path_of_name = diary.current.name.__path

      example.name = false
      Chambermaid.write example

      assert !File.exists?(path_of_name)
    end
  end
  def test_page_is_versioned
    write_example do |example, page|
      diary = browser[example.id]
      page_1 = diary.current

      example.name = false
      commit = browser.store(example).__context.commit

      assert_equal page_1.__context.commit, commit.parents.first
    end
  end
  def test_page_can_be_submodule
    # writing:
    # consumer does not write into local copy, only create the repository (local and remote if not exists [1]),
    # register self (.git/observer.yml) and create the current state (if 1).
    # when provider receives a commit, or a new tag is created, or blabla then
    # pull changes at the reference
    # reading:
    # means tree object is a submodule
    # reading does not change, imho
  end

end
