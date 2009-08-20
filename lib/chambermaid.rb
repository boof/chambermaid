module Chambermaid
  autoload :Diary, __FILE__.insert(-4, '/diary')
  autoload :Browser, __FILE__.insert(-4, '/browser')

  @browser = {}

  class << self
    def keep_diary(subject, opts = {})
      browser_class = opts.delete(:browser) || Browser
      @browser[ subject.name ] = browser_class.new subject, opts

      ascribe subject
    end
    def browser(subject)
      @browser.fetch subject.name
    end
    alias_method :[], :browser
    def ascribe(subject)
      subject_browser = browser subject
      return yield subject_browser.initializer if block_given?

      begin
        init_rb = File.join subject_browser.location, 'init.rb'
        load init_rb
      rescue TypeError
        raise 'root not specified'
      end
    end
    def write(object)
      browser(object.class).find object
    end
    
  end

end
