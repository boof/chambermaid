module Chambermaid::Interfaces
  module Browser
    include Enumerable

    # Returns an instance of Diary. The path is build from given values.
    #
    # This creates a new diary if it does not exist.
    def diary(object)
      open pathf % extract_values(object)
    end
    alias_method :%, :diary

    def [](values)
      open pathf % values
    end

    # Yields given block for each diary passing the diary to the block.
    def each
      Dir[ path_pattern ].each { |path| yield open(path) }
    end
    # Returns an instance of Diary at the given <tt>path</tt>.
    def open(path, mode = 'r')
      (self.class)::Diary.new path if mode == 'w' or File.directory? path
    end
    # Saves an object to the current chapter of the diary.
    def store(object, message = object.inspect)
      diary = open pathf % extract_values(object), 'w'
      diary.pages.create object, message
    end

  end
end
