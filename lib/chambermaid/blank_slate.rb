module Chambermaid
  class BlankSlate
    KEEP = /(?:\A__|class|object_id|instance_variable_set)/
    instance_methods.each { |meth| undef_method(meth) unless meth =~ KEEP }
  end
end
