module Mida

  # Class used to describe a property
  class PropertyDesc
    def initialize(num, &block)
      @types = [] 
      if block_given?
        instance_eval(&block)
      else
        types(String)
      end
      @num = num
    end

    # The types a property can take. E.g. +String+, or another +Vocabulary+
    # in order of preference
    # If you want to say any type, then use +:any+ as the class
    def types(*type_classes)
      @types += type_classes
    end

    def to_h
      {num: @num, types: @types || [String]}
    end

  end

end
