require_relative '../../../test_helper'

describe CrunchApi::Response::SupplierCollectionResponse do
  describe "multiple suppliers in the collection" do
    it "returns an array with two suppliers in it" do
      xml = <<XML
            <crunchMessage>
              <suppliers count="2" firstResut="0">
                <supplier supplierId='1' resourceUrl='/1'></supplier>
                <supplier supplierId='2' resourceUrl='/2'></supplier>
              </suppliers>
            </crunchMessage>
XML

      result = CrunchApi::Response::SupplierCollectionResponse.new(xml).suppliers

      result.must_be_kind_of Array
      result.size.must_equal 2
      result.first.must_be_kind_of CrunchApi::Supplier
    end
  end
  
  describe "a single supplier in the collection" do
    it "returns an array with one supplier in it" do
      xml = <<XML
            <crunchMessage>
              <suppliers count="1" firstResut="0">
                <supplier supplierId='1' resourceUrl='/1'></supplier>
              </suppliers>
            </crunchMessage>
XML

      result = CrunchApi::Response::SupplierCollectionResponse.new(xml).suppliers

      result.must_be_kind_of Array
      result.size.must_equal 1
      result.first.must_be_kind_of CrunchApi::Supplier
    end
  end

  describe "a response returned with outcome=success" do
    it "is a success" do
      xml = "<crunchMessage outcome='success'></crunchMessage>"

      result = CrunchApi::Response::SupplierCollectionResponse.new(xml)

      assert result.success?
    end
  end

  describe "a response returned with outcome=removed" do
    it "is a success" do
      xml = "<crunchMessage outcome='removed'></crunchMessage>"

      result = CrunchApi::Response::SupplierCollectionResponse.new(xml)

      assert result.success?
    end
  end

  describe "a response returned with outcome=failure" do
    it "is not a success" do
      xml = "<crunchMessage outcome='failure'></crunchMessage>"

      result = CrunchApi::Response::SupplierCollectionResponse.new(xml)

      refute result.success?
    end
  end
end

