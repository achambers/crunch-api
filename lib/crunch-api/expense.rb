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
        @supplier_reference = expense_details[:supplier_reference]
        @date = expense_details[:posting_date]
        
        supplier_attributes = expense_details.fetch(:supplier, nil)
        @supplier = CrunchApi::Supplier.new(supplier_attributes) if supplier_attributes
      end
    end

    def self.all
      response = make_request(:get, path)

      response_objects = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(response.body).map
      response_objects.collect{|attributes| new(attributes)}
    end

    def self.for_id(id)
      uri = "#{path}/#{id}"
      
      response = make_request(:get, uri)      

      if success?(response.body)
        response_objects = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(response.body).map
        new(response_objects.first) 
      end
    end

    private

    def self.path
      "#{CrunchApi.options[:endpoint]}/crunch-core/seam/resource/rest/api/expenses"
    end

    def self.to_hash(xml)
      mappings = {
          :@supplierId => :id,
          :@resource_url => :uri,
          :@default_expense_type => :default_expense_type,
          :@unknown_supplier => :unknown_supplier_flag,
          :@expenseId => :id
      }

      Nori.new(:convert_tags_to => lambda { |tag| mappings[tag.to_sym] || tag.snakecase.to_sym }).parse(xml)
    end

    def self.make_request(method, uri, xml=nil)
      if [:put, :post].include?(method)
        return token.send(method, uri, xml, {'Content-Type'=>'application/xml'})
      end
      token.send(method, uri)
    end

    def self.success?(xml)
      %w(success removed).include?(to_hash(xml)[:crunch_message][:@outcome])
    end

  end
end
