class Chambermaid::Diary
  autoload :About, __FILE__.insert(-4, '/about')
  autoload :Page, __FILE__.insert(-4, '/page')

  attr_reader :about

  def initialize(subject, opts)
    @about = About.new self, opts
    @subject_name = subject.name
  end
  def subject
    Object.const_get @subject_name
  end

  def each
    about.reader.each { |page| yield page }
  end
  include Enumerable

end
