Chambermaid.draft Teaser do |about|

  about.attribute :id, 'int.:id', :id => /\d+/
  about.attribute :content, 'txt'

  about.map :meta, 'yml' do |meta|
    meta.reader(:headline) { |meta| meta['headline'] }
  end

  about.attribute :url, 'uri'

end
