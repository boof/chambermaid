require 'pp'
require 'test/unit'
require 'profiler'

require 'rubygems'
require 'chambermaid'

require 'example'

module Helper
  module TestContext

    def assert_repository(sample)
      repository_exists = FileTest.directory? root(sample)
      repository_exists &&= FileTest.directory? join(sample, '.git')

      assert repository_exists, "repository in #{ root sample } expected"
    end

    def build_example(name = 'test')
      Example.build name
    end
    def build_example_with_children(name = 'parent', count = 5)
      parent = build_example name
      1.upto(count) { |i| parent << build_example("child #{ i }") }

      parent
    end
    def write_and_delete(example)
      yield example, Chambermaid.write(example)
    ensure
      FileUtils.rm_r root rescue nil
      raise $! if $!
    end
    def write_example(name = 'test')
      example = build_example name
      write_and_delete(example) { |example, page| yield example, page }
    end
    def write_example_with_children(name = 'parent', count = 5)
      example = build_example_with_children name, count
      write_and_delete(example) { |example, page| yield example, page }
    end

    unless defined? ROOT
      root = File.join File.dirname(__FILE__), 'tmp', '%i.example'
      ROOT = File.expand_path root
    end
    def root(*args)
      if sample = args.first
        ROOT % sample.id
      else
        File.join File.dirname(__FILE__), 'tmp'
      end
    end
    def join(sample, name)
      File.join root(sample), name
    end

  end
end
