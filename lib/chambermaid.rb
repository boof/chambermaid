module Chambermaid
  autoload :Diary, __FILE__.insert(-4, '/diary')
  autoload :Browser, __FILE__.insert(-4, '/browser')

  @browser = {}

  class << self
    def keep_diary(subject, opts = {})
      browser_class   = opts.delete(:browser) || Browser
      subject_browser = browser_class.new subject, opts
      @browser[ subject.name ] = subject_browser

      begin
        load File.join(subject_browser.location, 'init.rb')
      rescue
        raise "could not load information about #{ subject.name } diary"
      end
    end
    def browser(subject)
      @browser.fetch subject.name
    end
    alias_method :[], :browser

    def ascribe(subject)
      yield browser(subject).initializer
    end

    def write(object, note)
      diary = browser(object.class).find object
      diary.pages.put object, note
    end

  end
end
