require 'nori'

module CrunchApi
  class Expense

    extend CrunchApi::Authenticatable

    attr_reader :id, :uri, :supplier, :supplier_reference, :date

    def initialize(attributes)
      if attributes
        @id = attributes[:id].to_i
        @uri = attributes[:uri]
       
        expense_details = attributes.fetch(:expense_details, {}) 
        if expense_details
          @supplier_reference = expense_details[:supplier_reference] 
          @date = expense_details[:posting_date]
          
          supplier_attributes = expense_details.fetch(:supplier, nil)
          @supplier = CrunchApi::Supplier.new(supplier_attributes) if supplier_attributes

        end
      end
    end

    def self.all
      http_response = make_request(:get, path)
      response = CrunchApi::Response::ExpenseCollectionResponse.new(http_response.body)

      response.expenses if response.success?
    end

    def self.for_id(id)
      uri = "#{path}/#{id}"
      http_response = make_request(:get, uri)      
      response = CrunchApi::Response::ExpenseCollectionResponse.new(http_response.body)

      response.expenses.first if response.success?
    end

    private

    def self.path
      "#{CrunchApi.options[:endpoint]}/crunch-core/seam/resource/rest/api/expenses"
    end

    def self.make_request(method, uri, xml=nil)
      if [:put, :post].include?(method)
        return token.send(method, uri, xml, {'Content-Type'=>'application/xml'})
      end
      token.send(method, uri)
    end
  end
end

