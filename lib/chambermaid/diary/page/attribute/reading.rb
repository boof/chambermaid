class Chambermaid::Diary::Page::Attribute
  class Reading < Filter

    new :txt do |context, value|
      ( value || context.data ).to_s
    end
    new :int do |context, value|
      Reading[ :txt ][ context, value ].to_i
    end
    new :yml, 'yaml' do |context, value|
      YAML.load Reading[ :txt ][ context, value ]
    end
    new :uri, 'uri' do |context, value|
      URI Reading[ :txt ][ context, value ]
    end

  end
end
