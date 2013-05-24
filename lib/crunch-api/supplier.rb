require 'nori'

module CrunchApi
  class Supplier

    extend CrunchApi::Authenticatable

    attr_reader :id, :uri, :name, :contact_name, :email, :website, :telephone, :fax, :default_expense_type

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

    def unknown_supplier?
      @unknown_supplier_flag
    end

    def self.all
      response = get(path)

      parse_xml(response.body).collect{|attributes| new(attributes)}
    end

    def self.for_id(id)
      uri = "#{path}/#{id}"

      response = get(uri)

      new(parse_xml(response.body)) if success?(response.body)
    end

    def self.add(attributes)
      xml = request_xml(attributes)

      response = post(path, xml)

      if success?(response.body)
        attributes[:id] = parse_xml(response.body)[:id]

        new(attributes)
      end
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
      to_hash(xml)[:crunch_message][:@outcome] == "success"
    end

    def self.request_xml(attributes)
      template = File.read('templates/supplier.erb')

      ERB.new(template, 0, '>').result(binding)
    end

    def self.post(uri, xml)
      token.post(uri, xml.gsub( "\r", "").gsub( "\n", ""), {'Content-Type'=>'application/xml'})
    end

    def self.get(uri)
      token.get(uri)
    end
  end
end