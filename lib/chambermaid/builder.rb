module Chambermaid
  class Builder

    attr_reader :classes

    DEF_ATTR_READER = <<-DEF
      def %s                                                                  # def id
        tree_object = __tree_object.contents.find { |o|                       #   tree_object = __tree_object.contents.
            o.name[0, %i] == '%s.'} rescue nil                                #     find { |o| o.name[0, 3] == 'id.' } rescue nil
                                                                              #
        get '%s', tree_object                                                 #   get 'id', tree_object
      end                                                                     # end
    DEF
    DEF_BUILDER = <<-DEF
      def __build                                                             # def __build
        %s                                                                    #   YAML.parse __tree_object.data
      end                                                                     # end
    DEF
    DEF_SERIALIZER = <<-DEF
      def __serialize(%s)                                                     # def __serialize(object)
        %s                                                                    #   YAML.dump object
      end                                                                     # end
    DEF
    AUTO_COMPLETE_BUILDER = proc do |d|
      d.builder <<-DEF
        instance = CLASSNAME.constantize.class_eval { allocate }
        __tree_object.contents.each do |tree_object|
          continue if tree_object.name == '.gitignore'

          i_var = :"@\#{ tree_object.name }"
          i_val = get(i_var, tree_object).read

          instance.instance_variable_set i_var, i_val
        end
        instance
      DEF
    end
    AUTO_COMPLETE_SERIALIZER = proc do
      d.serializer :object => <<-DEF
        File.directory? __path or FileUtils.mkdir_p __path
        object.instance_variables.each do |i_var|
          i_val = object.instance_variable_get i_var
          i_var = i_var.to_s[ 1.. -1 ]
          set(i_var, i_val).write
        end
      DEF
    end

    def self.evaluate(name, extname)
      instance = new name, extname
      yield instance

      instance.auto_complete
      instance.evaluate

      instance.classes
    end

    def initialize(name, extname)
      @name, @extname = name, extname
      @classes = Hash.new { |h, k| h[k] = build_class k }

      @browser_evals, @diary_evals, @chapter_evals, @page_evals = '', '', '', ''
      browser   = Chambermaid.apply :browser, @classes[:Browser]
      diary     = Chambermaid.apply :diary, @classes[:Diary]
      chapter   = Chambermaid.apply :chapter, @classes[:Chapter]
      page      = Chambermaid.apply :page, @classes[:Page]
      frontpage = Chambermaid.apply :frontpage, Class.new(page)
      browser.const_set :Diary, diary
      diary.const_set :Chapter, chapter
      chapter.const_set :Page, page
      chapter.const_set :Frontpage, frontpage
      page_eval "def __extname; '#{ @extname }' end"

      @auto_complete = {
        :builder => AUTO_COMPLETE_BUILDER,
        :serializer => AUTO_COMPLETE_SERIALIZER
      }
    end

    def evaluate
      @classes[:Browser].class_eval @browser_evals
      @classes[:Diary].class_eval @diary_evals
      @classes[:Chapter].class_eval @chapter_evals
      @classes[:Page].class_eval @page_evals
    end

    def browser_eval(code)
      @browser_evals << "#{code}\n"
    end
    def diary_eval(code)
      @diary_evals << "#{code}\n"
    end
    def chapter_eval(code)
      @chapter_evals << "#{code}\n"
    end
    def page_eval(code)
      @page_evals << "#{code}\n"
    end

    def root(root_path, *args)
      root_path = File.expand_path root_path

      separator, extname = File::Separator, @extname
      pathf = "#{ root_path }#{ separator }#{ args.shift }#{ @extname }"

      extractor = args.map { |a| "object.__send__(:#{a})" } * ', '
      wildcards = args.map { |*| "**" }
      wildcards[-1] = "*"
      path_pattern = pathf % wildcards

      browser_eval <<-RUBY
        def extract_values(object) return #{ extractor } end
        def path_pattern; '#{ path_pattern }' end
        def pathf; '#{ pathf }' end
        def root; '#{ root_path }' end
      RUBY
      diary_eval <<-RUBY
        def extract_values(object) return #{ extractor } end
        def pathf; '#{ pathf }' end
      RUBY
    end

    def attr_reader(*attrs)
      attrs.each do |attr|
        attr = attr.to_s
        page_eval DEF_ATTR_READER % [ attr, attr.length + 1, attr, attr ]
      end
    end

    def builder(method = nil, &block)
      case method
#      when Symbol
#        classes[:Page].on_include { |base|
#            base.class_eval { alias __build method } }
      when String
        page_eval DEF_BUILDER % method
      else
        @classes[:Page].class_eval { define_method :__build, &block }
      end
      @auto_complete.delete :builder
    end
    def serializer(method_def = nil, &block)
      if Hash === method_def
        page_eval DEF_SERIALIZER % [
          method_def.keys.first,
          method_def.values.first
        ]
      else
        @classes[:Page].class_eval { define_method :__serialize, &block }
      end
      @auto_complete.delete :serializer
    end

    def auto_complete
      @auto_complete.each { |name, complete| complete[self] }
    end

    protected

      def build_class(super_name)
        built_class = Class.new BlankSlate
        built_class.class_eval "def self.name; '#{ @name }' end"

        built_class
      end

  end
end
