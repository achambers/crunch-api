require_relative '../../../test_helper'

describe CrunchApi::Response::SupplierObjectResponse do
  it "returns a supplier" do
    xml = "<crunchMessage><supplier supplierId='1'/></crunchMessage>"

    result = CrunchApi::Response::SupplierObjectResponse.new(xml).supplier

    result.must_be_kind_of CrunchApi::Supplier
  end

  describe "a response returned with outcome=success" do
    it "is a success" do
      xml = "<crunchMessage outcome='success'></crunchMessage>"

      result = CrunchApi::Response::SupplierObjectResponse.new(xml)

      assert result.success?
    end
  end

  describe "a response returned with outcome=removed" do
    it "is a success" do
      xml = "<crunchMessage outcome='removed'></crunchMessage>"

      result = CrunchApi::Response::SupplierObjectResponse.new(xml)

      assert result.success?
    end
  end

  describe "a response returned with outcome=failure" do
    it "is not a success" do
      xml = "<crunchMessage outcome='failure'></crunchMessage>"

      result = CrunchApi::Response::SupplierObjectResponse.new(xml)

      refute result.success?
    end
  end
end
