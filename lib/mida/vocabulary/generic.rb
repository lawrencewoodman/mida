module Mida
  module Vocabulary

    # A Generic vocabulary that will match against anything
    class Generic < Mida::VocabularyDesc
      itemtype %r{}
      has_many :any do
        extract :any
      end
    end

  end

end
