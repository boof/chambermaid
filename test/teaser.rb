class Teaser
  attr_accessor :id, :headline, :content, :url

  def initialize(id = nil, attrs = {})
    @id = id
    attrs.each { |attr, val| instance_variable_set :"@#{ attr }", val }
  end

  def to_s
    "#{ headline }\n#{ content }\n#{ url }"
  end

  def ==(other)
    @id and other.is_a? Teaser and @id == other.id
  end

end

Chambermaid.keep_diary Teaser,
  :in => "#{ File.dirname __FILE__ }/teasers",
  :as => :id
