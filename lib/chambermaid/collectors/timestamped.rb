module Chambermaid::Collectors
  module Timestamped
    def self.included(base)
      base.instance_variable_set :@timestamp, Time.at(0)
    end

    protected

      def fresh?
        @timestamp > mtime rescue false
      end
      def refresh
        @timestamp = mtime rescue @timestamp
      end
      def mtime
        File.mtime path
      end

  end
end
