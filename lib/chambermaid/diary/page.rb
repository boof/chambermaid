class Chambermaid::Diary::Page
  autoload :Attribute, __FILE__.insert(-4, '/attribute')
  autoload :Context, __FILE__.insert(-4, '/context')

  alias_method :__instance_variable_set, :instance_variable_set
  instance_methods.each { |meth| undef_method(meth) unless meth =~ /\A__/ }

  def initialize(about, tree, subject = nil)
    @about, @tree = about, tree
    @loaded = @subject = subject
  end

  # Delegates call to loaded subject. Unless loaded tries to read or write the
  # single attribute if defined. Otherwise the subject is read and the call is
  # delegated to the subject.
  def method_missing(method, *args, &block)
    # TODO: print out warning
    return @subject.__send__(method, *args, &block) if @loaded

    match = /(.+)(=)?$/.match method.to_s
    attribute, setter = match[1], match[2]

    if attribute = @about[ attribute ]
      context = Context.new attribute, @tree
      __bind_context attribute, context
      setter ? context.value = args.first : context.value
    else
      subject.__send__ attribute, *args, &block
    end
  end

  # Loads and returns the subject.
  def subject
    __load_subject
    @subject
  end

  # Returns previous page or nil when it does not exist.
  def previous
    raise NotImplementedError, 'previous is not implemented'
  end
  # Returns next page or nil when it does not exist.
  def next
    raise NotImplementedError, 'next is not implemented'
  end

  def sha1
    @tree.id
  end

  protected

    def __bind_context(method, context)
      __instance_variable_set :"@__context_of_#{ method }", context
      (class << self; self; end).module_eval <<-DEF
        def #{ method }
          @__context_of_#{ method }.value
        end
        def #{ method }=(value)
          @__context_of_#{ method }.value = value
        end
      DEF
    end
    def __load_subject
      return if @loaded
      @subject = @loaded = @about.reader.call(@about, @tree)
    end

end
