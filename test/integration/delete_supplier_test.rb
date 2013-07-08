require_relative '../test_helper'

describe "DELETE supplier integration" do
  before do
    CrunchApi.configure do |config|
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  it "returns the correct fields" do
    VCR.use_cassette('delete_supplier_success') do
      result = CrunchApi::Supplier.delete(844)

      assert result
    end
  end
end

