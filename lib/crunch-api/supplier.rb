require 'nori'

module CrunchApi
  class Supplier

    extend CrunchApi::Authenticatable

    attr_reader :id, :uri, :default_expense_type, :unknown_supplier_flag, :name, :contact_name, :email, :website, :telephone, :fax

    def initialize(xml)
      @id = xml[:id].to_i
      @uri = xml[:uri]
      @default_expense_type = xml[:default_expense_type]
      @unknown_supplier_flag = xml[:unknown_supplier_flag] == "true"
      @name = xml[:name]
      @contact_name = xml[:contact_name]
      @email = xml[:email]
      @website = xml[:website]
      @telephone = xml[:telephone]
      @fax = xml[:fax]
    end

    def self.all(options={})
      query_string = options_to_query_string(options)

      uri = "#{path}#{query_string}"

      response = make_request(:get, uri)

      parse_xml(response.body).collect{|attributes| new(attributes)}
    end

    def self.for_id(id)
      uri = "#{path}/#{id}"

      response = make_request(:get, uri)

      new(parse_xml(response.body)) if success?(response.body)
    end

    def self.add(attributes)
      xml = request_xml(attributes)

      response = make_request(:post, path, xml)

      if success?(response.body)
        attributes[:id] = parse_xml(response.body)[:id]

        new(attributes)
      end
    end

    def self.update(id, attributes)
      uri = "#{path}/#{id}"

      xml = request_xml(attributes)

      response = make_request(:put, uri, xml)

      if success?(response.body)
        attributes[:id] = id

        new(attributes)
      end
    end

    def self.delete(id)
      uri = "#{path}/#{id}"

      response = make_request(:delete, uri)

      success?(response.body)
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

    def self.parse_xml(xml)
      hash = to_hash(xml)
      hash = hash[:crunch_message][:suppliers] || hash[:crunch_message]
      hash[:supplier]
    end

    def self.to_hash(xml)
      mappings = {
          :@supplierId => :id,
          :@resource_url => :uri,
          :@default_expense_type => :default_expense_type,
          :@unknown_supplier => :unknown_supplier_flag
      }

      Nori.new(:convert_tags_to => lambda { |tag| mappings[tag.to_sym] || tag.snakecase.to_sym }).parse(xml)
    end

    def self.success?(xml)
      %w(success removed).include?(to_hash(xml)[:crunch_message][:@outcome])
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