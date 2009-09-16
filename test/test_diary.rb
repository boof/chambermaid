require 'test_helper'

class TestDiary < Test::Unit::TestCase
  include Helper::TestContext

  def example_diary_class
    Chambermaid::DIARIES['Example']
  end
  def setup
    @browser = Chambermaid.browser Example
  end

  def test_all_examples_are_serialized
    write_example_with_children 'foo', 3 do |example, page|
      assert_kind_of example_diary_class, @browser[example]
      example.children.each do |child|
        assert_kind_of example_diary_class, @browser[child]
      end
    end
  end

end

__END__
now = Time.now
page = @browser.diary(example).current
printf "\nTime to setup page: %.2fs\n\n", Time.now - now
now = Time.now
page.read
printf "\nTime to deserialize: %.2fs\n\n", Time.now - now
