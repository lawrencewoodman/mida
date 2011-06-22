require_relative 'vocabulary'

module Mida

  # A Generic vocabulary that will match against anything
  class GenericVocabulary < Mida::Vocabulary
    itemtype %r{}
    has_many :any do
      extract :any
    end
  end

end
