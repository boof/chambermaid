Chambermaid.ascribe Teaser do |has|

  has.accessor :id, 'int.%'
  has.accessor :content

#  has.attribute :image, 'file'

  has.map :meta do |meta|
    meta.accessor :headline,
        :reader => proc { |meta| meta['headline'] },
        :writer => proc { |meta, teaser| meta['headline'] = teaser.headline }
  end

  has.accessor :url, 'uri'

end
