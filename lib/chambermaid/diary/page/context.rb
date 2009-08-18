class Chambermaid::Diary::Page::Context

  attr_reader :attribute, :tree

  def initialize(attribute, tree)
    @attribute, @tree = attribute, tree
  end

  def value
    @value ||= attribute[ self ]
  end
  def value=(value)
    raise NotImplementedError
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
        case filename = @attribute.filename
        when String; @tree / filename
        when Regexp; @tree.contents.find { |o| o.name =~ filename }
        end
      end
    end

end
