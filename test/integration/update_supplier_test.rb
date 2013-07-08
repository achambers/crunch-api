require_relative '../test_helper'

describe "UPDATE supplier integration" do
  before do
    CrunchApi.configure do |config|
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  it "returns the correct fields" do
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

      supplier = CrunchApi::Supplier.update(844, attributes)

      supplier.must_be_kind_of CrunchApi::Supplier
      supplier.id.must_equal 844
      supplier.default_expense_type.must_equal "GENERAL_INSURANCE"
      #supplier.uri.must_equal "/crunch-core/seam/resource/rest/api/suppliers/711"
      supplier.name.must_equal "Waitrose"
      supplier.contact_name.must_equal "Mark Hamill"
      supplier.email.must_equal "mark@waitrose.com"
      supplier.website.must_equal "waitrose.com"
      supplier.telephone.must_equal "1111111"
      supplier.fax.must_equal "02987654321"
      #assert supplier.unknown_supplier?
    end
  end
end

