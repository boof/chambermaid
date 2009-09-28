require 'test_helper'

class TestExampleChambermaid < Test::Unit::TestCase
  include Helper::TestContext

  unless defined? String1
    String1 = Class.new String
    String2 = Class.new String1
  end

  def test_lookup_for_unknown_class_names
    assert_equal 'String', Chambermaid::Page[ String1.name ].name
    assert_equal 'String', Chambermaid::Page[ String2.name ].name
  end

end
