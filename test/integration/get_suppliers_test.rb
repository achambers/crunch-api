require_relative '../test_helper'

describe "GET suppliers integration" do
  before do
    CrunchApi.configure do |config|
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  it "returns the correct fields" do
    VCR.use_cassette('get_suppliers_success') do
      suppliers = CrunchApi::Supplier.all

      suppliers.size.must_equal 6
      suppliers.must_be_kind_of Array
      suppliers.first.must_be_kind_of CrunchApi::Supplier
      suppliers.first.id.must_equal 709
      suppliers.first.default_expense_type.must_equal "EQUIPMENT_COST"
      suppliers.first.uri.must_equal "/crunch-core/seam/resource/rest/api/suppliers/709"
      suppliers.first.name.must_equal "Apple Inc"
      suppliers.first.contact_name.must_equal "Joe Burns"
      suppliers.first.email.must_equal "test@apple.com"
      suppliers.first.website.must_equal "apple.com"
      suppliers.first.telephone.must_equal "0212345"
      suppliers.first.fax.must_equal "029876"
      assert suppliers.first.unknown_supplier?
    end
  end
end

