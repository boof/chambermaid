class Chambermaid::Diary::Page::Context

  attr_reader :attribute, :tree

  def initialize(attribute, tree)
    @attribute, @tree, @loaded = attribute, tree, false
  end

  def value
    @attribute.read self unless loaded?
    @value
  end
  def value=(value)
    @value, @loaded = value, true
  end

  def raw
    blob.data
  end

  protected

    def blob
      @blob ||= begin
        prefix  = "#{ @attribute.name }."
        n       = prefix.length

        @tree.contents.find { |o| o.name[0, n] == prefix }
      end
    end

    attr_reader :loaded; alias_method :loaded?, :loaded

end
