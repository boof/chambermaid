Chambermaid.ascribe Teaser do |has|

  has.attribute :id, 'int.:id', :id => /\d+/
  has.attribute :content, 'txt'

  has.map :meta, 'yml' do |meta|
    meta.reads(:headline) { |meta| meta['headline'] }
  end

  has.attribute :url, 'uri'

end
