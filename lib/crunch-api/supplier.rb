module CrunchApi
  class Supplier

    extend CrunchApi::Authenticatable

    attr_reader :id, :uri, :default_expense_type, :unknown_supplier_flag, :name, :contact_name, :email, :website, :telephone, :fax

    def initialize(xml)
      if xml
        @id = xml[:id].to_i
        @uri = xml[:uri]
        @default_expense_type = xml[:default_expense_type]
        @unknown_supplier_flag = (xml[:unknown_supplier_flag] == "true")
        @name = xml[:name]
        @contact_name = xml[:contact_name]
        @email = xml[:email]
        @website = xml[:website]
        @telephone = xml[:telephone]
        @fax = xml[:fax]
      end
    end

    def self.all(options={})
      query_string = options_to_query_string(options)
      uri = "#{path}#{query_string}"
      http_response = make_request(:get, uri)
      response = CrunchApi::Response::SupplierCollectionResponse.new(http_response.body)
      
      response.suppliers if response.success?
    end

    def self.for_id(id)
      uri = "#{path}/#{id}"

      http_response = make_request(:get, uri)

      response = CrunchApi::Response::SupplierCollectionResponse.new(http_response.body)
      response.suppliers.first if response.success?
    end

    def self.add(attributes)
      xml = request_xml(attributes)
      
      http_response = make_request(:post, path, xml)
      response = CrunchApi::Response::SupplierObjectResponse.new(http_response.body)
      
      if response.success?
        attributes[:id] = response.supplier.id
        new(attributes)
      end
    end

    def self.update(id, attributes)
      uri = "#{path}/#{id}"
      xml = request_xml(attributes)

      http_response = make_request(:put, uri, xml)
      response = CrunchApi::Response::SupplierObjectResponse.new(http_response.body)
      
      if response.success?
        attributes[:id] = id
        new(attributes)
      end
    end

    def self.delete(id)
      uri = "#{path}/#{id}"

      http_response = make_request(:delete, uri)
      response = CrunchApi::Response::SupplierObjectResponse.new(http_response.body)

      response.success?
    end

    def unknown_supplier?
      @unknown_supplier_flag
    end

    def [](method)
      self.send(method)
    end

    def []=(method, value)
      self.instance_variable_set("@#{method}", value)
    end

    private

    def self.path
      "#{CrunchApi.options[:endpoint]}/crunch-core/seam/resource/rest/api/suppliers"
    end

    def self.request_xml(attributes)
      template = File.read('templates/supplier.erb')

      ERB.new(template, 0, '>').result(binding).gsub( "\r", "").gsub( "\n", "")
    end

    def self.make_request(method, uri, xml=nil)
      if [:put, :post].include?(method)
        return token.send(method, uri, xml, {'Content-Type'=>'application/xml'})
      end
      token.send(method, uri)
    end

    def self.default_options
      {first_result: 0}
    end

    def self.options_to_query_string(options)
      options = default_options.merge(options)

      options.inject("?") { |str, arr| str << "#{arr[0].to_s.gsub(/_([a-z])/) { $1.upcase }}=#{arr[1]}&" }
    end
  end
end
