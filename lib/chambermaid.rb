require 'enumerator'
require 'fileutils'
require 'forwardable'
require 'ostruct'

require 'active_support/inflector'
require 'grit'

require 'vendor/IniFile/lib/ini_file'

module Chambermaid

  EXTNAME_TO_CLASSNAME  = {}

  def self.describe(klass, opts = {})
    name = klass.name
    extname = opts.fetch :as, name.underscore

    EXTNAME_TO_CLASSNAME[extname] = name
    extname = ".#{ extname }"

    create_contexts(name, extname) { |desc| yield desc }
  end

  def self.browser(klass)
    if browser = Browser[ klass.name ] then browser.new end
  end
  def self.diary(object)
    if browser = browser(object.class) then browser.diary object end
  end
  def self.write(object, message = object.inspect)
    if browser = browser(object.class) then browser.store object, message
    else
      raise TypeError, "#{ object.class } does not have a browser"
    end
  end

  private

    def self.each_context
      [ :Browser, :Diary, :Chapter, :Page ].each { |ctx| yield ctx }
    end
    each_context do |c|
      const_set c, Hash.new { |h, n| h[ "#{ n }".constantize.superclass.name ] if n != 'Object' }
    end

    def self.create_contexts(name, extname, &block)
      classes = Builder.evaluate name, extname, &block

      each_context do |c|
        const_get(c)[name] = const_set "#{ name }#{ c }", classes[c]
      end
    end

end

%w[ blank_slate
    interfaces types builder
    git_dir references collectors
  ].each { |lib| require __FILE__.insert(-4, "/#{ lib }") }
