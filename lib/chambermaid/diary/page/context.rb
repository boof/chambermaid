class Chambermaid::Diary::Page::Context

  attr_reader :attribute, :tree

  def initialize(attribute, tree)
    @attribute, @tree = attribute, tree
  end

  def value
    @value ||= @attribute[ self ]
  end

  def data
    blob.data
  end
  def name
    blob.name
  end

  def reading_units
    name.split('.')[ 1.. -1 ].reverse
  end

  protected

    def blob
      @blob ||= begin
        prefix  = "#{ @attribute.name }."
        n       = prefix.length

        @tree.contents.find { |o| o.name[0, n] == prefix }
      end
    end

end
