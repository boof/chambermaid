class Chambermaid::Diary::About
  autoload :Draft, __FILE__.insert(-4, '/draft')
  autoload :Reader, __FILE__.insert(-4, '/readers')
  autoload :CachedReader, __FILE__.insert(-4, '/readers')

  class << self; attr_accessor :reader end
  self.reader = Reader

  def initialize(diary, opts)
    @diary, @location = diary, opts[:in]

    @attributes   = {}
    @reader = (opts[:reader] || self.class.reader).new self
  end

  attr_reader \
    :diary, :location,
    :attributes, :reader, :writer, :builder

  def subject
    @diary.subject
  end

  def [](attribute)
    @attributes[ attribute ] or
        raise NameError, "attribute #{ attribute } is not defined"
  end
  def reading(attribute)
    @attributes[attribute].reading
  end

  def draft
    yield Draft.new(@attributes = {})
  end

end
