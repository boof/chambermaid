module Chambermaid::Types
  %w[
    nil_class true_class false_class
    integer complex float
    string symbol
    array hash
    file
  ].
  each { |i| require __FILE__.insert(-4, "/#{ i }") }
end
