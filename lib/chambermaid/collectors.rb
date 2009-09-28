module Chambermaid::Collectors
  %w[
    timestamped
    chapters pages
  ].
  each { |i| require __FILE__.insert(-4, "/#{ i }") }
end
