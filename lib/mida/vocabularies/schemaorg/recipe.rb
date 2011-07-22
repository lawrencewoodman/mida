require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Duration, 'mida/vocabularies/schemaorg/duration'
    autoload :NutritionInformation, 'mida/vocabularies/schemaorg/nutritioninformation'

    # A recipe.
    class Recipe < Mida::Vocabulary
      itemtype %r{http://schema.org/Recipe}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The time it takes to actually cook the dish, in ISO 8601 duration format.
      has_many 'cookTime' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # The method of cooking, such as Frying, Steaming, ...
      has_many 'cookingMethod'

      # An ingredient used in the recipe.
      has_many 'ingredients'

      # Nutrition information about the recipe.
      has_many 'nutrition' do
        extract Mida::SchemaOrg::NutritionInformation
        extract Mida::DataType::Text
      end

      # The length of time it takes to prepare the recipe, in ISO 8601 duration format.
      has_many 'prepTime' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # The category of the recipe - for example, appetizer, entree, etc.
      has_many 'recipeCategory'

      # The cuisine of the recipe (for example, French or Ethopian).
      has_many 'recipeCuisine'

      # The steps to make the dish.
      has_many 'recipeInstructions'

      # The quantity produced by the recipe (for example, number of people served, number of servings, etc).
      has_many 'recipeYield'

      # The total time it takes to prepare and cook the recipe, in ISO 8601 duration format.
      has_many 'totalTime' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end
    end

  end
end
