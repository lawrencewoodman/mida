module Mida

  # Class used to describe a property
  class PropertyDesc
    def initialize(num, &block)
      @types = [] 
      if block_given?
        instance_eval(&block)
      else
        types(:text)
      end
      @num = num
    end

    # The types a property can take.
    # This can be a datatype such as +:text+ or a +Vocabulary+.
    # The types should be supplied in order of preference.
    # If you want to say any type, then use +:any+ as the class
    def types(*types)
      @types += types
    end

    def to_h
      {num: @num, types: @types || [:text]}
    end

  end

end
