require_relative '../../test_helper'

describe CrunchApi::Supplier do
  describe "Initialization" do
    [:name, :contact_name, :email, :website, :telephone, :fax].each do |attribute|
      it "sets the attribute for #{attribute}" do
        supplier = CrunchApi::Supplier.new(attribute.to_sym => "foo")

        supplier.send(attribute).must_equal "foo"
      end
    end

    it "sets the attribute for id" do
      supplier = CrunchApi::Supplier.new(:@supplierId => "foo")

      supplier.id.must_equal "foo"
    end

    it "sets the attribute for uri" do
      supplier = CrunchApi::Supplier.new(:@resourceUrl => "foo")

      supplier.uri.must_equal "foo"
    end

    it "sets the attribute for default expense type" do
      supplier = CrunchApi::Supplier.new(:@defaultExpenseType => "foo")

      supplier.default_expense_type.must_equal "foo"
    end

    it "sets the attribute for unknown supplier" do
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

    it "calls the correct resource" do
      VCR.use_cassette('get_suppliers_success') do
        CrunchApi::Supplier.all

        assert_requested(:get, 'https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers')
      end
    end

    it "returns an array of suppliers" do
      VCR.use_cassette('get_suppliers_success') do
        suppliers = CrunchApi::Supplier.all

        suppliers.size.must_equal 6
        suppliers.must_be_kind_of Array
        suppliers.first.must_be_kind_of CrunchApi::Supplier
        suppliers.first.name.must_equal "Apple Inc"
      end
    end
  end

  describe "GET /suppliers/{id}" do
    before do
      CrunchApi.configure do |config|
        config.endpoint = "https://demo.crunch.co.uk"
      end
    end

    it "calls the correct resource" do
      VCR.use_cassette('get_supplier_by_id_success') do
        CrunchApi::Supplier.for_id(711)

        assert_requested(:get, 'https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers/711')
      end
    end

    describe "an existing supplier" do
      it "returns a supplier" do
        VCR.use_cassette('get_supplier_by_id_success') do
          supplier = CrunchApi::Supplier.for_id(711)

          supplier.must_be_kind_of CrunchApi::Supplier
          supplier.name.must_equal "BT"
        end
      end
    end

    describe "an unknown supplier" do
      it "returns nil" do
        VCR.use_cassette('get_supplier_by_id_failure') do
          supplier = CrunchApi::Supplier.for_id(999)

          supplier.must_be_nil
        end
      end
    end
  end
end