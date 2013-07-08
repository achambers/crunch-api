require_relative '../../test_helper'

describe CrunchApi::Supplier do
  before do
    CrunchApi.configure do |config|
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  describe "Initialization" do
    [:name, :contact_name, :email, :website, :telephone, :fax].each do |attribute|
      it "sets the attribute for #{attribute}" do
        supplier = CrunchApi::Supplier.new(attribute.to_sym => "foo")

        supplier.send(attribute).must_equal "foo"
      end
    end

    it "sets the attribute for id" do
      supplier = CrunchApi::Supplier.new(:id => 1)

      supplier.id.must_equal 1
    end

    it "sets the attribute for uri" do
      supplier = CrunchApi::Supplier.new(:uri => "foo")

      supplier.uri.must_equal "foo"
    end

    it "sets the attribute for default expense type" do
      supplier = CrunchApi::Supplier.new(:default_expense_type => "foo")

      supplier.default_expense_type.must_equal "foo"
    end

    it "sets the attribute for unknown supplier" do
      supplier = CrunchApi::Supplier.new(:unknown_supplier_flag => "true")

      supplier.unknown_supplier?.must_equal true
    end
  end

  describe "GET /suppliers" do
    it "calls the correct resource" do
      VCR.use_cassette('get_suppliers_success') do
        CrunchApi::Supplier.all

        assert_requested(:get, "https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers?firstResult=0")
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

    describe "pagination" do
      it "returns the specified supplier as the first result" do
        VCR.use_cassette('get_suppliers_pagination_first_result_success') do
          suppliers = CrunchApi::Supplier.all(first_result: 5)

          suppliers.size.must_equal 5
          suppliers.first.name.must_equal "E-Crunch Ltd"
        end
      end

      it "returns the specified number of suppliers" do
        VCR.use_cassette('get_suppliers_pagination_results_per_page_success') do
          suppliers = CrunchApi::Supplier.all(results_per_page: 4)

          suppliers.size.must_equal 4
        end
      end
    end
  end

  describe "GET /suppliers/{id}" do
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

  describe "POST /suppliers" do
    it "calls the correct resource" do
      VCR.use_cassette('add_supplier_success') do
        CrunchApi::Supplier.add({})

        assert_requested(:post, 'https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers')
      end
    end

    describe "a successful request" do
      it "creates a the supplier with all fields" do
        VCR.use_cassette('add_supplier_success') do
          attributes = {
              default_expense_type: "GENERAL_INSURANCE",
              name: "Waitrose",
              contact_name: "Mark Hamill",
              email: "mark@waitrose.com",
              website: "waitrose.com",
              telephone: "02123456789",
              fax: "02987654321"
          }

          supplier_id = CrunchApi::Supplier.add(attributes)

          supplier_id.must_equal 844
        end
      end
    end

    describe "a failed request" do
      it "returns nil" do
        VCR.use_cassette('add_supplier_failure') do
          attributes = {
              default_expense_type: "GENERAL_INSURANCE",
          }

          supplier = CrunchApi::Supplier.add(attributes)

          supplier.must_be_nil
        end
      end
    end
  end

  describe "PUT /suppliers/{id}" do
    it "calls the correct resource" do
      VCR.use_cassette('update_supplier_success') do
        CrunchApi::Supplier.update(844, {})

        assert_requested(:put, 'https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers/844')
      end
    end

    describe "a successful request" do
      it "returns the updated supplier" do
        VCR.use_cassette('update_supplier_success') do
          attributes = {
              default_expense_type: "GENERAL_INSURANCE",
              name: "Waitrose",
              contact_name: "Mark Hamill",
              email: "mark@waitrose.com",
              website: "waitrose.com",
              telephone: "1111111",
              fax: "02987654321"
          }

          supplier_id = CrunchApi::Supplier.update(844, attributes)

          supplier_id.must_equal 844
        end
      end

      it "accepts a supplier object" do
        VCR.use_cassette('update_supplier_success') do
          attributes = {
              default_expense_type: "GENERAL_INSURANCE",
              name: "Waitrose",
              contact_name: "Mark Hamill",
              email: "mark@waitrose.com",
              website: "waitrose.com",
              telephone: "1111111",
              fax: "02987654321"
          }

          supplier = CrunchApi::Supplier.new(attributes)

          supplier_id = CrunchApi::Supplier.update(844, supplier)

          supplier_id.must_equal 844
        end
      end
    end

    describe "a failed request" do
      it "returns nil" do
        VCR.use_cassette('update_supplier_failure') do
          attributes = {
              default_expense_type: "GENERAL_INSURANCE",
          }

          supplier = CrunchApi::Supplier.update(844, attributes)

          supplier.must_be_nil
        end
      end
    end
  end

  describe "DELETE /suppliers/{id}" do
    it "calls the correct resource" do
      VCR.use_cassette('delete_supplier_success') do
        CrunchApi::Supplier.delete(844)

        assert_requested(:delete, 'https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/suppliers/844')
      end
    end

    describe "a successful request" do
      it "returns true" do
        VCR.use_cassette('delete_supplier_success') do
          result = CrunchApi::Supplier.delete(844)

          result.must_equal true
        end
      end
    end

    describe "a failed request" do
      it "returns false" do
        VCR.use_cassette('delete_supplier_failure') do
          result = CrunchApi::Supplier.delete(844)

          result.must_equal false
        end
      end
    end
  end
end
