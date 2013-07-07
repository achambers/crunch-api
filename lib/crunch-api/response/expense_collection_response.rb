require 'nori' 
module CrunchApi
  module Response
    class ExpenseCollectionResponse
      def initialize(response)
        @response = response
      end

      def success?
        %w(success).include?(as_hash[:crunch_message][:@outcome])
      end

      def expenses
        result = as_hash[:crunch_message][:expenses][:expense]
        
        if result.is_a?(Hash)
          return [CrunchApi::Expense.new(result)]
        end

        result.collect{|attributes| CrunchApi::Expense.new(attributes)}
      end

      private

      def as_hash
        mappings = {
          :@expenseId => :id,
          :@resourceUrl => :uri,
        }
        Nori.new(:convert_tags_to => lambda { |tag| mappings[tag.to_sym] || tag.snakecase.to_sym }).parse(@response)
      end
    end
  end
end


