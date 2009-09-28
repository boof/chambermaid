module Chambermaid::Types
  class NilClass < Chambermaid::BlankSlate
    def self.name; 'NilClass' end
    Chambermaid::Page[name] = self

    def __serialize; end
    def __build; end

    include Chambermaid::Interfaces::Page
  end
end
