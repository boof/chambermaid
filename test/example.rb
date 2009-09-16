class Example
  IDs = Hash.new { |h, name| h[name] = h.size + 1 }
  INSTANCEs = {}

  def self.build(name)
    new IDs[name], name
  end
  def initialize(id, name)
    INSTANCEs[id] = self
    IDs[name] = id unless IDs.member? name

    @id, @name, @children = id, name, []
  end

  def <<(example)
    @children.push example
  end
  attr_reader :id, :name, :children

end

Chambermaid.describe Example do |desc|
  root = File.join File.dirname(__FILE__), 'tmp'

  desc.root root, '%s', :id
  desc.attr_accessor :id, :name, :children

  desc.serializer :example => <<-RUBY
    set(:id, example.id).write
    set(:name, example.name).write
    set(:children, example.children).write
  RUBY
  desc.builder <<-RUBY
    example = Example.new id.read, name.read
    children.each { |context| example << context.read }

    example
  RUBY
end
