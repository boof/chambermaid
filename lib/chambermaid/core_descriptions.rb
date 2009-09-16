Chambermaid.describe NilClass, :as => nil do |desc|

  desc.serializer :signature => ''
  desc.builder ''

end
Chambermaid.describe Object, :as => 'yml' do |desc|

  desc.serializer do |object|
    File.directory? __dirname or FileUtils.mkdir_p __dirname
    File.open(__path, 'w') { |f| f.write YAML.dump(object) }

    __repository.add __name
  end
  desc.builder 'YAML.parse __tree_object.data'

end
Chambermaid.describe String, :as => 'txt' do |desc|

  desc.serializer :string => <<-RUBY
    File.directory? __dirname or FileUtils.mkdir_p __dirname
    File.open(__path, 'w') { |f| f.write string }

    __repository.add __name
  RUBY
  desc.builder '__tree_object.data'

end
Chambermaid.describe Integer, :as => nil do |desc|

  desc.serializer :signature => <<-RUBY
    File.directory? __dirname or FileUtils.mkdir_p __dirname
    File.exists? __path or FileUtils.touch __path

    __repository.add __name
  RUBY
  desc.builder 'Integer __tree_object.name[/\d+$/]'

end
Chambermaid::CLASSNAMES.default = 'Integer'

Chambermaid.describe Array do |desc|

  desc.serializer :array => <<-RUBY
    File.directory? __path or FileUtils.mkdir_p __path
    path_gitignore = File.join __path, '.gitignore'
    File.exists? path_gitignore or FileUtils.touch path_gitignore

    index = 0
    array.each do |value|
      set(index, value).write
      index += 1
    end

    __repository.add __name
  RUBY
  desc.builder <<-RUBY
    objects = []
    each do |c|
      index = Integer c.__tree_object.name[/^\d+/]
      objects[ index ] = c.read
    end

    objects
  RUBY

end
Chambermaid.describe Hash do |desc|

  desc.serializer :hash => <<-RUBY
    File.directory? __path or FileUtils.mkdir_p __path
    path_gitignore = File.join __path, '.gitignore'
    File.exists? path_gitignore or FileUtils.touch path_gitignore

    hash.each { |key, value| set(key, value).write }

    __repository.add __name
  RUBY
  desc.builder <<-RUBY
    objects = {}
    each do |c|
      key = c.__tree_object.name[/^[^\.]+/]
      objects[ key ] = c.read
    end

    objects
  RUBY

end
