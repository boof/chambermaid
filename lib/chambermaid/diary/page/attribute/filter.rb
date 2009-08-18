require 'yaml'
require 'uri'

class Chambermaid::Diary::Page::Attribute::Filter < Proc

  def self.new(name = nil, *prerequisites, &strategy)
    prerequisites.each { |lib| require lib }

    filter = super(&strategy)
    @filters[ name.to_sym ] = filter if name

    filter
  end

  def self.inherited(base)
    base.instance_variable_set :@filters,
        Hash.new { |m, name| self.new { |*| "#{ name }" } }
  end

  def self.[](name)
    @filters[ name.to_sym ]
  end

end
