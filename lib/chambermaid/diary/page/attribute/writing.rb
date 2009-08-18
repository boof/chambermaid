class Chambermaid::Diary::Page::Attribute
  class Writing < Filter

    new :txt do |context, value|
      context.file << value
    end
    new :int do |context, value|
      value.to_s
    end
    new :yml, 'yaml' do |context, value|
      value.to_yaml
    end
    new :uri do |context, value|
      value.to_s
    end

  end
end
