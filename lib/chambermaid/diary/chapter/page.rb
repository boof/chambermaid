module Chambermaid
  class Diary
    class Chapter
      # This is the abstract Transfer Object class.
      class Page < BasicObject
        extend Forwardable
        def_delegators :@origin, :__repository

        # Returns extname for current object. This is either the assigned,
        # or the strigified object itself prefixed with '.' if not assigned.
        def __extname
          EXTNAME || ".#{ @object }"
        end

        module Root
          def __repository
            # chapter returns repository on repository, not __repository
            @origin.repository
          end
          def __tree_object
            # this is already assigned by instance of Pages
            @tree_object
          end
          def __name(*names)
            # glue names here
            names * '/'
          end
          def write
            # skip the garbage collection
            __serialize @object
          end
        end

        def self.root(chapter, opts)
          instance = new chapter, opts
          instance.extend Root
        end

        def initialize(origin, opts = {})
          @origin = origin

          @object = opts[:object] if opts.member? :object
          @tree_object = opts[:tree_object] if opts.member? :tree_object

          @name = opts[:name]
          @extname = __extname if @name
        end

        # Constructs name and returns it.
        def __name(*names)
          names.unshift "#{ @name }#{ @extname }"
          @origin.__name(*names)
        end

        # Constructs path and returns it.
        def __path
          @path ||= File.join __repository.working_dir, __name
        end

        # Decorates tree_object.
        def get(attr, tree_object)
          page_class = if tree_object
            name, extname = tree_object.name.split '.', 2
            PAGES[ CLASSNAMES[extname] ]
          else
            NilClassPage
          end

          page_class.new self, :name => name, :tree_object => tree_object
        end

        # Returns instance of page class with name and tree object.
        def each
          __tree_object.contents.each { |to|
              to.name == '.gitignore' or yield get(to.name, to) }
        end

        def set(attr, object)
          # TODO: instantiate diaries to create child repositories
          page_class = Chambermaid.blank_page object
          page_class.new self, :name => attr.to_s, :object => object
        end

        # Garbage collects old tree object and calls serialize.
        def write
          __gc
          __serialize @object
        end
        # Loads unloaded object and returns it.
        def read
          @object = __build unless defined? @object
          @object
        end

        def method_missing(m, *a, &b)
          instance_methods = Object.const_get(CLASSNAME).instance_methods
          if instance_methods.include?(m) or instance_methods.include?(m.to_s)
            read.__send__ m, *a, &b
          else
            super
          end
        end

        def __tree_object
          unless defined? @tree_object
            o_name = "#{ @name }."; length = o_name.length
            @tree_object = @origin.__tree_object.contents.
                find { |o| o.name[0, length] == o_name }
          end

          @tree_object
        end

        protected

          # Garbage collects old tree object.
          def __gc
            o_name = "#{ @name }."; length = o_name.length
            @origin.__tree_object.contents.each { |o|
              puts "Removing #{ o.name }..."
              __repository.remove o.name if o.name[0, length] == o_name
            }
          rescue
          end
          def __dirname
            File.dirname __path
          end

      end
    end
  end

  Page = Diary::Chapter::Page
end
