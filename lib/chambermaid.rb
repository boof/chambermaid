require 'enumerator'
require 'fileutils'
require 'forwardable'
require 'ostruct'

# require 'rubygems'
require 'active_support/inflector'
require 'grit'

require 'vendor/IniFile/lib/ini_file'

module Chambermaid

   # Loads multiple files from this directory.
  def self.require_each(*libs)
    libs.each { |lib| require __FILE__.insert(-4, "/#{ lib }") }
  end

  def self.each_context
    [ :Browser, :Diary, :Chapter, :Page ].each { |ctx| yield ctx }
  end
  each_context do |c|
    const_set c, Hash.new { |h, n| h[ "#{ n }".constantize.superclass.name ] if n != 'Object' }
  end
  EXTNAME_TO_CLASSNAME  = {}

  def self.class_name(object)
    object = object.class unless Class === object
    object.name
  end

  def self.describe(object, opts = {})
    name = class_name object
    extname = opts.fetch :as, name.underscore

    if extname
      EXTNAME_TO_CLASSNAME[extname] = name
      extname = ".#{ extname }"
    end

    create_contexts(name, extname) { |desc| yield desc }
  end

  def self.browser(object)
    if browser = Browser[ class_name(object) ] then browser.new end
  end
  def self.diary(object)
    if browser = browser(object) then browser.diary object end
  end
  def self.write(object, message = object.inspect)
    if browser = browser(object) then browser.store object, message
    else
      raise ArgumentError
    end
  end

  private

    def self.create_contexts(name, extname, &block)
      classes = Builder.evaluate name, extname, &block

      each_context do |c|
        const_get(c)[name] = const_set "#{ name }#{ c }", classes[c]
      end
    end

end

Chambermaid.require_each 'blank_slate', 'ini',
    'interfaces', 'types', 'builder',
    'git_dir', 'references', 'collectors'
