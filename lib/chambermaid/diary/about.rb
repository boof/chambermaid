class Chambermaid::Diary::About
  autoload :Draft, __FILE__.insert(-4, '/draft')
  autoload :Reader, __FILE__.insert(-4, '/readers')
  autoload :CachedReader, __FILE__.insert(-4, '/readers')
  class << self
    attr_accessor :reader
  end
  self.reader = Reader

  def initialize(diary, opts)
    @diary        = diary

    @attributes   = {}
    @location     = opts[:in] # || ''

    @reader = if reader = opts[:reader]
          reader.new self
        else
          self.class.reader.new self
        end
  end

  attr_reader :diary, :reader, :writer, :attributes, :location, :constructor

  def subject
    @diary.subject
  end
  def [](attribute)
    @attributes[attribute]
  end
  def reading(attribute)
    @attributes[attribute].reading
  end
  def writing(attribute)
    @attributes[attribute].writing
  end

  def draft
    yield Draft.new(@attributes = {})
  end

end
