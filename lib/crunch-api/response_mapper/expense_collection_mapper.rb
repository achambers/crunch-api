require 'nori'

module CrunchApi
  module ResponseMapper
    class ExpenseCollectionMapper
      def initialize(xml)
        @xml = xml
      end

      def map
        mappings = {
          :@expenseId => :id,
          :@resourceUrl => :uri,
        }
        result = Nori.new(:convert_tags_to => lambda { |tag| mappings[tag.to_sym] || tag.snakecase.to_sym }).parse(@xml)
        collection = result[:crunch_message][:expenses][:expense]
        
        if collection.is_a?(Hash)
          return [collection]
        end

        collection
      end
    end
  end
end
