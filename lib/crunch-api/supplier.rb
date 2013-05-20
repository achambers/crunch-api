require 'oauth'
require 'nori'

module CrunchApi
  class Supplier

    attr_reader :id, :uri, :name, :contact_name, :email, :website, :telephone, :fax, :default_expense_type

    def initialize(xml)
      @id = xml[:@supplierId]
      @uri = xml[:@resourceUrl]
      @default_expense_type = xml[:@defaultExpenseType]
      @unknown_supplier_flag = xml[:@unknownSupplier] == "true"
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
      consumer = OAuth::Consumer.new(CrunchApi.options[:consumer_key], CrunchApi.options[:consumer_secret], {})
      token = OAuth::AccessToken.new(consumer, CrunchApi.options[:oauth_token], CrunchApi.options[:oauth_token_secret])

      uri = "#{CrunchApi.options[:endpoint]}#{path}"

      response = token.get(uri)

      parse_xml(response.body).collect{|attributes| new(attributes)}
    end

    def self.for_id(id)
      consumer = OAuth::Consumer.new(CrunchApi.options[:consumer_key], CrunchApi.options[:consumer_secret], {})
      token = OAuth::AccessToken.new(consumer, CrunchApi.options[:oauth_token], CrunchApi.options[:oauth_token_secret])

      uri = "#{CrunchApi.options[:endpoint]}#{path}/#{id}"

      response = token.get(uri)

      new(parse_xml(response.body)) unless errors?(response.body)
    end

    private

    def self.path
      "/crunch-core/seam/resource/rest/api/suppliers"
    end

    def self.parse_xml(xml)
      to_hash(xml)[:crunch_message][:suppliers][:supplier]
    end

    def self.to_hash(xml)
      Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym }).parse(xml)
    end

    def self.errors?(xml)
      to_hash(xml)[:crunch_message].fetch(:errors, []).length > 0
    end
  end
end