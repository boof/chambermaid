require 'rubygems'
require 'grit'

class Chambermaid::Browser
  About, Diary = Chambermaid::Diary::About, Chambermaid::Diary
  include Grit

  def initialize(subject, opts)
    @about = About.new subject, opts
  end

  def subject
    @about.subject
  end
  def location
    @about.location
  end
  def initializer
    @about.initializer
  end

  def diary(entry)
    path = File.join location, entry.to_s
    build_diary path
  end
  alias_method :[], :diary
  alias_method :at, :diary

  def each_diary
    each_directory { |path| yield build_diary(path) }
  end
  def diaries
    collection = []
    each_diary { |diary| collection << diary }
    collection
  end

  protected

    def each_directory
      Dir.open location do |dir|
        while entry = dir.read
          next if entry[0, 1] == '.'
          path = File.join location, entry
          yield path if File.directory? path
        end
      end
    end
    def build_diary(path)
      # TODO: init repo on-the-fly
      Diary.new @about, Repo.new(path)
    end

end
