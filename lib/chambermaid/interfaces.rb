module Chambermaid
  module Interfaces
    %w[ browser diary chapter page frontpage ].
    each { |i| require __FILE__.insert(-4, "/#{ i }") }
  end
  def self.apply(interface, base)
    interface = Interfaces.const_get "#{ interface }".classify
    base.class_eval { include interface }

    base
  end
end
