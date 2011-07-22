#!/usr/bin/env ruby
# Creates the vocabulary classes for schema.org from vocabularies.json
# which is held at https://github.com/LawrenceWoodman/schema.org_schemas 
# The classes are created in vocabularies/
require 'erb'
require 'json'
require 'set'

VOCABULARY_TEMPLATE = <<-EOB
require 'mida/vocabulary'

module Mida
  module SchemaOrg

% types_used = types_used(vocabulary)
% types_used(vocabulary).each do |klass|
    autoload :<%= klass %>, 'mida/vocabularies/schemaorg/<%= klass.downcase %>'
% end

    # <%= vocabulary['description'] %>
    class <%= vocabulary['name'] %> < Mida::Vocabulary
      itemtype %r{http://schema.org/<%= vocabulary['name'] %>}i
% if vocabulary.has_key?('vocabularies')
%   vocabulary['vocabularies'].each do |include_vocabulary|
      include_vocabulary Mida::SchemaOrg::<%= include_vocabulary %>
%   end
% end
% if vocabulary.has_key?('properties')
%  vocabulary['properties'].each do |property|

      # <%= property['description'] %>
%     if property['types'] == ['Text']
      has_many '<%= property['name'] %>'
%     else
      has_many '<%= property['name'] %>' do
%       types = types_normalize(property['types'])
%       types.each do |type|        
        extract <%= type %>
%       end
      end
%     end
%   end
% end
    end

  end
end
EOB

DATATYPES = {
  'Boolean' => 'Mida::DataType::Boolean',
  'Date' => 'Mida::DataType::ISO8601Date',
  'Float' => 'Mida::DataType::Float',
  'Integer' => 'Mida::DataType::Integer',
  'Number' => 'Mida::DataType::Number',
  'URL' => 'Mida::DataType::URL',
  'Text' => 'Mida::DataType::Text',
}

def types_normalize(types)
  normalized_types = types.collect do |type|
    if DATATYPES.include?(type)
      DATATYPES[type]
    else
      "Mida::SchemaOrg::#{type}"
    end
  end
  
  normalized_types = normalized_types.sort do |a,b|
    if a=~ /^Mida::DataType::Text/ && b!=~/^Mida::DataType::Text/
      1
    elsif b=~ /^Mida::DataType::Text/ && a!=~/^Mida::DataType::Text/
      -1
    else
      0
    end
  end

  if normalized_types.any? {|type| type =~/^Mida::SchemaOrg::/} &&
     !normalized_types.include?('Mida::DataType::Text')
    normalized_types << 'Mida::DataType::Text'
  end
  normalized_types
end

def types_used(vocabulary)
  types = Set.new
  if vocabulary.has_key?('vocabularies')
    vocabulary['vocabularies'].each do |vocabulary|
      types << vocabulary
    end
  end

  if vocabulary.has_key?('properties')
    vocabulary['properties'].each do |property|
      property['types'] .each do |type|
        unless DATATYPES.include?(type)
          types << type
        end
      end
    end
  end
  types
end

def get_requires(vocabulary)
  types = types_used(vocabulary)
  types.collect do |type|
    "mida/vocabularies/schemaorg/#{type.downcase}"
  end
end

vocabularies = JSON.parse(File.read('vocabularies.json'))

Dir.mkdir('vocabularies') unless File.directory?('vocabularies')

vocabularies.each do |vocabulary|
  File.open("vocabularies/#{vocabulary['name'].downcase}.rb", 'w') do |file|
    file.puts ERB.new(VOCABULARY_TEMPLATE, 0, '%').result(binding)
  end
end
