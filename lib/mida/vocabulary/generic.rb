module Mida
  module Vocabulary

    # A Generic vocabulary that will match against anything
    class Generic < Mida::VocabularyDesc
      itemtype_regexp %r{}
      has_many :any do
        types :any
      end
    end

  end

  register_vocabulary(Vocabulary::Generic)
end
