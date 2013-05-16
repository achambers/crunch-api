require_relative '../../test_helper'

describe CrunchApi::Supplier do
  describe "Initialization" do
    [:name, :contact_name, :email, :website, :telephone, :fax].each do |attribute|
      it "should set the attribute for #{attribute}" do
        supplier = CrunchApi::Supplier.new(attribute.to_sym => "foo")

        supplier.send(attribute).must_equal "foo"
      end
    end

    it "should set the attribute for id" do
      supplier = CrunchApi::Supplier.new(:@supplierId => "foo")

      supplier.id.must_equal "foo"
    end

    it "should set the attribute for uri" do
      supplier = CrunchApi::Supplier.new(:@resourceUrl => "foo")

      supplier.uri.must_equal "foo"
    end

    it "should set the attribute for default expense type" do
      supplier = CrunchApi::Supplier.new(:@defaultExpenseType => "foo")

      supplier.default_expense_type.must_equal "foo"
    end

    it "should set the attribute for unknown supplier" do
      supplier = CrunchApi::Supplier.new(:@unknownSupplier => "true")

      supplier.unknown_supplier?.must_equal true
    end
  end

  describe "GET /suppliers" do
    before do
      CrunchApi.configure do |config|
        config.endpoint = "https://demo.crunch.co.uk"
      end
    end

    it "should call the correct resource" do
      VCR.use_cassette('get_suppliers_success') do
        CrunchApi::Supplier.all

        assert_requested(:get, 'https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers')
      end
    end

    it "should return an array of suppliers" do
      VCR.use_cassette('get_suppliers_success') do
        suppliers = CrunchApi::Supplier.all

        suppliers.size.must_equal 6
        suppliers.must_be_kind_of Array
        suppliers.first.must_be_kind_of CrunchApi::Supplier
        suppliers.first.name.must_equal "Apple Inc"
      end
    end
  end
end