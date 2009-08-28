class Chambermaid::Diary::Page::Context

  attr_reader :attribute, :tree

  def initialize(attribute, tree)
    @attribute, @tree, @loaded = attribute, tree, false
  end

  def value
    @attribute.deserialize self unless loaded?
    @value
  end
  def value=(value)
    @value, @loaded = value, true
  end

  def repo
    @tree.instance_variable_get :@repo
  end
  def raw
    blob.data
  end

  def blob
    @blob ||= begin
      prefix  = "#{ @attribute.name }."
      n       = prefix.length

      @tree.contents.find { |o| o.name[0, n] == prefix }
    end
  end

  protected

    attr_reader :loaded; alias_method :loaded?, :loaded

end
