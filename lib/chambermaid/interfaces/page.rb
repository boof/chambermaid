module Chambermaid::Interfaces
  module Page

    def self.included(base)
      owner = base.name.constantize

      instance_methods = [ true, false ].
      map { |arg| owner.instance_methods(arg).map { |m| m.to_sym }.inspect }

      base.class_eval <<-DEF
        def self.instance_methods(all = true)
          all ? #{ instance_methods * ' : ' }
        end
        def methods
          #{ instance_methods.first }
        end
      DEF
    end

    # repository, branch, treeish, parent, name, ancestors
    def initialize(name, context, attrs = {})
      @name, @context = name, context
      attrs.each { |key, value| instance_variable_set :"@#{ key }", value }
    end

    def method_missing(m, *a, &b)
      if methods.include? m
        read.__send__ m, *a, &b
      else
        super
      end
    end

    def __context
      @context
    end
    def __context=(context)
      @context = context
    end

    # Constructs name and returns it.
    def __name(names = [])
      #if names.empty?
      #  @name ||= @origin.__name names.unshift("#{ @name }#{ @extname }")
      #else
        @origin.__name names.unshift("#{ @name }#{ __extname }")
      #end
    end

    # Constructs path and returns it.
    def __path
      @path ||= File.join @context.path, __name
    end

    def __tree_object
      unless defined? @tree_object
        o_name = "#{ @name }."; length = o_name.length
        @tree_object = @origin.__tree_object.contents.
            find { |o| o.name[0, length] == o_name }
      end

      @tree_object
    end

    # Decorates tree_object.
    def get(name, tree_object)
      if tree_object
        split_name = tree_object.name.split '.'
        class_name = Chambermaid::EXTNAME_TO_CLASSNAME[split_name.pop]

        # TODO: typecast name
        name = name.to_s
      else
        class_name = 'NilClass'
      end

      # TODO: switch context here when tree object is a submodule
      context = @context

      Chambermaid::Page[class_name].new name, context,
          :origin => self, :tree_object => tree_object
    end

    def set(name, object)
      page_class = Chambermaid::Page[ object.class.name ]

      if browser = Chambermaid.browser(object.class)
        context = if diary = browser % object
          diary.current.__context
        else
          browser.store(object).__context
        end
      else
        context = @context
      end

      child = page_class.new name, context,
          :origin => self, :object => object
      @context.references[child.__name] ||= context if context != @context

      child
    end

    # Loads unloaded object and returns it.
    def read
      @object = __build unless defined? @object
      @object
    end
    # Garbage collects old tree object and calls serialize.
    def write
      __gc
      __serialize @object
    end

    protected

      # TODO: move to context, name as param?
      # Garbage collects old tree object.
      def __gc
        begin
          # TODO: delete from observers
          o_name = "#{ @name }."; length = o_name.length
          @origin.__tree_object.contents.each { |o|
            @context.repository.remove o.name if o.name[0, length] == o_name
          }
        rescue NoMethodError
        end
      end

  end
end
