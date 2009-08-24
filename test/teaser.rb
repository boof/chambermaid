class Teaser
  attr_accessor :id, :headline, :content, :url

  def to_s
    "#{ headline }\n#{ content }\n#{ url }"
  end

end

Chambermaid.keep_diary Teaser,
  :in => "#{ File.dirname __FILE__ }/teasers",
  :as => :id
