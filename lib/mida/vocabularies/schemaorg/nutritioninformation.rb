require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Energy, 'mida/vocabularies/schemaorg/energy'
    autoload :Mass, 'mida/vocabularies/schemaorg/mass'

    # Nutritional information about the recipe.
    class NutritionInformation < Mida::Vocabulary
      itemtype %r{http://schema.org/NutritionInformation}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The number of calories
      has_many 'calories' do
        extract Mida::SchemaOrg::Energy
        extract Mida::DataType::Text
      end

      # The number of grams of carbohydrates.
      has_many 'carbohydrateContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of milligrams of cholesterol.
      has_many 'cholesterolContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of fat.
      has_many 'fatContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of fiber.
      has_many 'fiberContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of protein.
      has_many 'proteinContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of saturated fat.
      has_many 'saturatedFatContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The serving size, in terms of the number of volume or mass
      has_many 'servingSize'

      # The number of milligrams of sodium.
      has_many 'sodiumContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of sugar.
      has_many 'sugarContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of trans fat.
      has_many 'transFatContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end

      # The number of grams of unsaturated fat.
      has_many 'unsaturatedFatContent' do
        extract Mida::SchemaOrg::Mass
        extract Mida::DataType::Text
      end
    end

  end
end
