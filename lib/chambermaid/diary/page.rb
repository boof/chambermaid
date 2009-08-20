class Chambermaid::Diary::Page
  autoload :Attribute, __FILE__.insert(-4, '/attribute')
  autoload :Context, __FILE__.insert(-4, '/context')

  alias_method :__instance_variable_set, :instance_variable_set
  instance_methods.each { |meth| undef_method(meth) unless meth =~ /\A__/ }

  def initialize(about, tree)
    @about, @loaded, @tree = about, false, tree
  end

  def method_missing(attribute, *args, &block)
    context = Context.new @about[attribute], @tree
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
      DEF
      __instance_variable_set :"@__context_of_#{ method }", context
    end
    def __load_target
      return unless defined? @loaded
      @target, @loaded = @about.builder.call(@about, @tree), true
    end

end
