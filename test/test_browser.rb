require 'test_helper'

class TestChambermaid < Test::Unit::TestCase
  include Helper::TestContext

  def example_diary_class
    Chambermaid::DIARIES['Example']
  end

  def setup
    @browser = Chambermaid.browser Example
  end

  def test_browser_finds_diaries_by_index
    write_example_with_children 'foo' do |example, page|
      @browser.each do |diary|
        assert_kind_of example_diary_class, @browser % diary.current.id
      end
    end
  end
  def test_browser_enumerates_over_each_diary
    write_example_with_children 'foo' do |example, page|
      @browser.each { |diary| assert_kind_of example_diary_class, diary }
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
