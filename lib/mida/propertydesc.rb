module Mida

  # Class used to describe a property
  class PropertyDesc
    def initialize(num, &block)
      @num, @types = num, []
      if block_given?
        instance_eval(&block)
        @types = [:text] unless @types.size >= 1
      else
        @types = [:text]
      end
    end

    # What to extract for this property.
    # This can be a datatype such as +:text+ or a +Vocabulary+.
    # The types should be supplied in order of preference.
    # If you want to say any type, then use +:any+ as the class
    def extract(*types)
      @types += types
    end

    # <b>DEPRECATED:</b> Please use +extract+ instead
    def types(*types)
      warn "[DEPRECATION] Mida::PropertyDesc#types is deprecated.  "+
           "Please use Mida::PropertyDesc#extract instead."
      extract *types
    end

    def to_h
      {num: @num, types: @types}
    end

  end

end
