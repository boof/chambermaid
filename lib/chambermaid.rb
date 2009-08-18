module Chambermaid
  autoload :Diary, __FILE__.insert(-4, '/diary')

  @diaries = {}
  def self.keep_diary(subject, opts = {})
    diary = Diary.new subject, opts
    @diaries[ subject.name ] = diary

    load "#{ File.join diary.about.location, 'init.rb' }"

    diary
  end

  def self.diary(subject)
    @diaries[ subject.name ]
  end
  def self.about(subject)
    diary(subject).about
  end
  def self.draft(subject, &block)
    about(subject).draft(&block)
  end

end
