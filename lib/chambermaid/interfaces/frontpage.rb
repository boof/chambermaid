module Chambermaid::Interfaces
  module Frontpage

    def initialize(context, attrs = {})
      @context = context
      attrs.each { |key, value| instance_variable_set :"@#{ key }", value }
    end

    # @origin is a chapter and only responds to repository.
    #
    # TODO:
    # Replaced @origin with a context object, containing repository branch,
    # treeish, name and origin.
    def __repository
      Kernel.warn "Don't call __repository anymore, use the @context.commit instead.\n" + caller.inspect
      @context.repository
    end

    # @origin is a chapter and only responds to tree.
    #
    # TODO:
    # Replaced @origin with a context object, containing repository branch,
    # treeish, name and origin.
    def __tree_object
      @context.tree
    end

    # Because <tt>self</tt> remains, skip the garbage collection.
    def write
      __serialize @object
      __context.references.dump
    end

    def __name(names = []) names * '/' end
    def __path; @context.path end

  end
end
