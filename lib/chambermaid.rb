require 'enumerator'
require 'fileutils'
require 'forwardable'
require 'grit'

module Chambermaid

  CLASSNAMES  = {}

  build_hash = proc {
    Hash.new do |hash, name|
      class_instance = name.split('::').
          inject(Object) { |parent, name| parent.const_get name }

      hash[ class_instance.superclass.name ]
    end
  }

  BROWSERS    = build_hash.call
  DIARIES     = build_hash.call
  CHAPTERS    = build_hash.call
  PAGES       = build_hash.call

   # Loads multiple files from this directory.
  def self.require_each(*libs)
    libs.each { |lib| require __FILE__.insert(-4, "/#{ lib }") }
  end
  # Underscores camelcased word.
  def self.underscore(object)
    camel_cased_word = "#{ object }"
    camel_cased_word.gsub!('::', '/')
    camel_cased_word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    camel_cased_word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    camel_cased_word.tr!('-', '_')
    camel_cased_word.downcase!

    camel_cased_word
  end

  def self.class_name(object)
    object = object.class unless Class === object
    object.name
  end

  def self.describe(object, opts = {})
    name = class_name object
    extname = opts.fetch :as, underscore(name)

    if extname
      CLASSNAMES[extname] = name
      extname = ".#{ extname }"
    end

    create_contexts(name, extname) { |desc| yield desc }
  end

  def self.browser(object)
    BROWSERS[ class_name(object) ].new
  end
  def self.diary(object)
    browser(object).diary object
  end

  def self.blank_page(object)
    PAGES[ class_name(object) ]
  end

  def self.write(object, message = object.inspect)
    browser(object.class).save object, message
  end

  private

    def self.build_mclass(name, extname)
      Class.new Module do
        def included(base)
          @on_include.each { |block| block[base] }
        end
        def on_include(&block)
          @on_include << block
        end
        define_method :initialize do
          @on_include = []
          const_set :CLASSNAME, name
          const_set :EXTNAME, extname
        end
      end
    end
    def self.describe_modules(name, extname)
      mclass    = build_mclass name, extname
      contexts  = %w[ Browser Diary Chapter Page ].map! { |k| k.to_sym }
      modules   = contexts.inject({}) { |m, k| m.update k => mclass.new }
      describer = Describer.new modules.values_at(*contexts)

      yield describer

      modules
    end
    def self.create_contexts(name, extname)
      modules = describe_modules(name, extname) { |desc| yield desc }

      {
        :Browser  => BROWSERS,
        :Diary    => DIARIES,
        :Chapter  => CHAPTERS,
        :Page     => PAGES
      }.
      each do |ctx, hash|
        ctx_class, ctx_module = const_get(ctx).clone, modules[ctx]
        ctx_class.class_eval { include ctx_module }

        hash[name] = const_set "#{ name }#{ ctx }", ctx_class
      end
    end

end

Chambermaid.require_each 'basic_object', 'browser', 'timestamped',
    'diary', 'diary/chapters', 'diary/chapter',
    'diary/chapter/pages', 'diary/chapter/page',
    'describer', 'core_descriptions'
