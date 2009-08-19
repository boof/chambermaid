require 'rubygems'
require 'grit'

class Chambermaid::Diary::Page
  autoload :Attribute, __FILE__.insert(-4, '/attribute')
  autoload :Context, __FILE__.insert(-4, '/context')

  alias_method :__instance_variable_set, :instance_variable_set
  instance_methods.each { |meth| undef_method(meth) unless meth =~ /\A__/ }

  include Grit

  def initialize(about, path)
    @about, @loaded, @repository = about, false, Repo.new(path)
    @builder = @about.builder || proc { |about, tree|
      instance = about.subject.new

      about.attributes.each do |name, attribute|
        instance.send "#{ name }=", Context.new(attribute, tree).value
      end

      instance
    }
  end

  def method_missing(attribute, *args, &block)
    context = Context.new @about[attribute], @repository.tree
    __bind_context attribute, context
    context.value
  end

  def target
    __load_target
    @target
  end

  def inspect; target.inspect end

  protected

    def __bind_context(method, context)
      (class << self; self; end).module_eval <<-DEF
        def #{ method }
          @__context_of_#{ method }.value
        end
        def #{ method }=(value)
          @__context_of_#{ method }.value = value
        end
      DEF
      __instance_variable_set :"@__context_of_#{ method }", context
    end
    def __load_target
      return unless defined? @loaded
      @target, @loaded = @builder.call(@about, @repository.tree), true
    end

end
