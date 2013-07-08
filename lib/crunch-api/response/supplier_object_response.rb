require 'nori'

module CrunchApi
  module Response
    class SupplierObjectResponse

      def initialize(response)
        @response = response
      end

      def success?
        %w(success removed).include?(as_hash[:crunch_message][:@outcome])
      end

      def supplier_id
        as_hash[:crunch_message][:supplier][:id].to_i
      end

      private

      def as_hash
        mappings = {
            :@supplierId => :id,
            :@resource_url => :uri,
            :@unknown_supplier => :unknown_supplier_flag
        }
        Nori.new(:convert_tags_to => lambda { |tag| mappings[tag.to_sym] || tag.snakecase.to_sym }).parse(@response)
      end
    end
  end
end

