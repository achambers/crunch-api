require_relative '../test_helper'

describe "GET supplier integration" do
  before do
    CrunchApi.configure do |config|
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  it "returns the correct fields" do
    VCR.use_cassette('get_supplier_by_id_success') do
      supplier = CrunchApi::Supplier.for_id(711)

      supplier.must_be_kind_of CrunchApi::Supplier
      supplier.id.must_equal 711
      supplier.default_expense_type.must_equal "INTERNET"
      supplier.uri.must_equal "/crunch-core/seam/resource/rest/api/suppliers/711"
      supplier.name.must_equal "BT"
      supplier.contact_name.must_equal "Sam Smith"
      supplier.email.must_equal "sam@bt.com"
      supplier.website.must_equal "bt.com"
      supplier.telephone.must_equal "0712345678"
      supplier.fax.must_equal "0212345678"
      assert supplier.unknown_supplier?
    end
  end
end

