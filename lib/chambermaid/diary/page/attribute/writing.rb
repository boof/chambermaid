class Chambermaid::Diary::Page::Attribute
  class Writing < Filter

    to_s = proc

    new :txt do |context, value|
      value.to_s
    end
    new :int do |context, value|
      raise TypeError unless Integer === value
      value.to_s
    end
    new :yml, 'yaml' do |context, value|
      value.to_yaml
    end
    new :uri do |context, value|
      raise TypeError unless URI === value
      value.to_s
    end

  end
end
