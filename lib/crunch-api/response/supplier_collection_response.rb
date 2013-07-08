require 'nori'

module CrunchApi
  module Response
    class SupplierCollectionResponse

      def initialize(response)
        @response = response
      end

      def success?
        %w(success removed).include?(as_hash[:crunch_message][:@outcome])
      end

      def suppliers
        result = as_hash[:crunch_message][:suppliers][:supplier]

        if result.is_a?(Hash)
          return [CrunchApi::Supplier.new(result)]
        end
        
        result.collect{|attributes| CrunchApi::Supplier.new(attributes)}
      end

      private

      def as_hash
        mappings = {
            :@supplierId => :id,
            :@resource_url => :uri,
            :@default_expense_type => :default_expense_type,
            :@unknown_supplier => :unknown_supplier_flag
        }
        Nori.new(:convert_tags_to => lambda { |tag| mappings[tag.to_sym] || tag.snakecase.to_sym }).parse(@response)
      end
    end
  end
end

