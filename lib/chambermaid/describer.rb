module Chambermaid
  class Describer

    def initialize(modules)
      @browser, @diary, @chapter, @page = modules
    end

    def root(root_path, *args)
      root_path = File.expand_path root_path

      separator, extname = File::Separator, @browser::EXTNAME
      pathf = "#{ root_path }#{ separator }#{ args.shift }#{ extname }"

      extractor = args.map { |a| "object.__send__(:#{a})" }
      wildcards = args.map { |*| "**" }
      wildcards[-1] = "*"
      path_pattern = pathf % wildcards

      @browser.module_eval <<-RUBY
        def extract_values(object) return #{ extractor * ', ' } end
        def path_pattern; '#{ path_pattern }' end
        def pathf; '#{ pathf }' end
        def root; '#{ root_path }' end
      RUBY
      @diary.module_eval <<-RUBY
        def extract_values(object) return #{ extractor * ', ' } end
        def pathf; '#{ pathf }' end
      RUBY
    end
    def attr_accessor(*attrs)
      attrs.each do |attr|
        @page.module_eval <<-RUBY
          def #{ attr }
            tree_object = __tree_object.contents.find { |o|
                o.name[0, #{ attr.to_s.length + 1 }] == '#{ attr }.'} rescue nil

            get '#{ attr }', tree_object
          end
        RUBY
      end
    end

    def builder(method = nil, &block)
      case method
      when Symbol
        @page.on_include { |base|
            base.class_eval { alias_method :__build, method } }
      when String
        @page.module_eval <<-RUBY
          def __build
            #{ method }
          end
        RUBY
      else
        @page.module_eval { define_method :__build, &block }
      end
    end
    def serializer(method_def = nil, &block)
      if Hash === method_def
        sig, body = method_def.first

        @page.module_eval <<-RUBY
          def __serialize(#{ sig })
            #{ body }
          end
        RUBY
      else
        @page.module_eval { define_method :__serialize, &block }
      end
    end

  end
end
