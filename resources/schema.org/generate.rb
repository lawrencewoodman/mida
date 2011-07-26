#!/usr/bin/env ruby
# Creates the vocabulary and enumeration classes for schema.org from
# vocabularies.json which is held at:
#   https://github.com/LawrenceWoodman/schema.org_schemas
# The classes are created in vocabularies/
require 'erb'
require 'json'
require 'set'

ENUMERATION_TEMPLATE = <<-EOB
require 'mida/datatype'

module Mida
  module SchemaOrg

    # <%= type.description %>
    class <%= type.name %> < Mida::DataType::Enumeration
      VALID_VALUES = [
% num_instances = type.instances.size
% type.instances.first(num_instances-1).each do |instance|
        [::Mida::DataType::URL, %r{http://schema.org/<%= instance %>}i],
% end
        [::Mida::DataType::URL, %r{http://schema.org/<%= type.instances.last %>}i]
      ]
    end

  end
end
EOB

VOCABULARY_TEMPLATE = <<-EOB
require 'mida/vocabulary'

module Mida
  module SchemaOrg

% type.types_used.each do |klass|
    autoload :<%= klass %>, 'mida/vocabularies/schemaorg/<%= klass.downcase %>'
% end

    # <%= type.description %>
    class <%= type.name %> < Mida::Vocabulary
      itemtype %r{http://schema.org/<%= type.name %>}i
% type.vocabularies.each do |include_vocabulary|
      include_vocabulary Mida::SchemaOrg::<%= include_vocabulary %>
% end
% type.properties.each do |property|

      # <%= property.description %>
%   if property.types.size == 1 && property.types[0].name == 'Text'
      has_many '<%= property.name %>'
%   else
      has_many '<%= property.name %>' do
%     property.types.each do |prop_type|
        extract <%= prop_type.full_name %>
%     end
      end
%   end
% end
    end

  end
end
EOB

DATATYPES = [
  {'name' => 'Boolean', 'full_name' => 'Mida::DataType::Boolean'},
  {'name' => 'Date', 'full_name' => 'Mida::DataType::ISO8601Date'},
  {'name' => 'Float', 'full_name' => 'Mida::DataType::Float'},
  {'name' => 'Integer', 'full_name' => 'Mida::DataType::Integer'},
  {'name' => 'Number', 'full_name' => 'Mida::DataType::Number'},
  {'name' => 'URL', 'full_name' => 'Mida::DataType::URL'},
  {'name' => 'Text', 'full_name' => 'Mida::DataType::Text'},
]

class Property
  
  attr_reader :name, :description, :types

  def initialize(name, description, types)
    @name = name
    @description = description
    @types = (types || []).collect {|type| Type.find(type)}.sort
    add_text_type(@types)
  end

  def add_text_type(types)
    if types.any? {|type| type.vocabulary?} &&
       types.none? {|type| type.name == 'Text'}
      @types << Type.find('Text')
    end
  end

end

class Type
  include Comparable

  attr_reader :name, :full_name, :description, :vocabularies, :properties
  attr_reader :instances

  def initialize(definition)
    @name = definition['name']
    @ancestors = definition['ancestors'] || []
    @description = definition['description']
    @vocabularies = definition['vocabularies'] || []
    @properties = definition['properties'] || []
    @instances = definition['instances'] || []
    @full_name = definition['full_name'] || "Mida::SchemaOrg::#{@name}"
    (@@types ||= []) << self
  end

  # Returns the found type or nil of not found
  def self.find(name)
    found_types = @@types.find_all {|type| type.name == name}
    found_types.any? ? found_types[0] : nil
  end

  def process_properties
    @properties = @properties.collect do |property|
      Property.new(property['name'], property['description'], property['types'])
    end
  end

  def types_used
    types = Set.new
    @vocabularies.each do |vocabulary|
      types << vocabulary
    end

    @properties.each do |property|
      property.types .each do |type|
        unless type.datatype?
          types << type.name
        end
      end
    end
    types
  end

  def get_requires(vocabulary)
    types = types_used(vocabulary)
    types.collect do |type|
      "mida/vocabularies/schemaorg/#{type.name.downcase}"
    end
  end

  def enumeration?
    @ancestors.include?('Enumeration')
  end

  def datatype?
    full_name =~ /^Mida::DataType::/
  end

  def vocabulary?
    !enumeration? && !datatype?
  end

  def <=>(other)
    if full_name =~ /^Mida::DataType::Text/ &&
       other.full_name !=~/^Mida::DataType::Text/
      1
    elsif other.full_name =~ /^Mida::DataType::Text/ &&
           full_name !=~/^Mida::DataType::Text/
      -1
    else
      full_name <=> other.full_name
    end
  end
end

types = JSON.parse(File.read('vocabularies.json'))
types = types.collect {|type| Type.new(type)}
datatypes = DATATYPES.collect {|type| Type.new(type)}
types.each {|type| type.process_properties}

Dir.mkdir('enumerations') unless File.directory?('enumerations')
Dir.mkdir('vocabularies') unless File.directory?('vocabularies')

types.each do |type|
  if type.enumeration?
    File.open("enumerations/#{type.name.downcase}.rb", 'w') do |file|
      file.puts ERB.new(ENUMERATION_TEMPLATE, 0, '%').result(binding)
    end
  elsif type.vocabulary?
    File.open("vocabularies/#{type.name.downcase}.rb", 'w') do |file|
      file.puts ERB.new(VOCABULARY_TEMPLATE, 0, '%').result(binding)
    end
  end
end
