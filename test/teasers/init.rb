Chambermaid.ascribe Teaser do |has|

  has.attribute :id, 'int.%i', :id
  has.attribute :content, 'txt'

  has.map :meta, 'yml' do |meta|
    meta.reads(:headline) { |meta| meta['headline'] }
  end

  has.attribute :url, 'uri'

end
