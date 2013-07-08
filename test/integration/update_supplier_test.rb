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

      supplier_id = CrunchApi::Supplier.update(844, attributes)

      supplier_id.must_equal 844
    end
  end
end

