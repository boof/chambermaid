class Teaser
  attr_accessor :id, :headline, :content, :url
end

Chambermaid.keep_diary Teaser,
  :in => "#{ File.dirname __FILE__ }/teasers",
  :as => :id
