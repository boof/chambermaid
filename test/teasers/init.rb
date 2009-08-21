Chambermaid.ascribe Teaser do |has|

  has.attribute :id, 'int.%i', :id
  has.attribute :content

  has.map :meta do |meta|
    meta.reads(:headline) { |meta| meta['headline'] }
  end

  has.attribute :url, 'uri'

end
