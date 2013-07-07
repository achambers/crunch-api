require_relative '../../../test_helper'

describe CrunchApi::Response::ExpenseCollectionResponse do
  describe "multiple expenses in the collection" do
    it "returns an array with two expenses in it" do
      xml = <<XML
            <crunchMessage>
              <expenses count="2" firstResut="0">
                <expense expenseId='1' resourceUrl='/1'><expenseDetails/></expense>
                <expense expenseId='2' resourceUrl='/2'><expenseDetails/></expense>
              </expenses>
            </crunchMessage>
XML

      result = CrunchApi::Response::ExpenseCollectionResponse.new(xml).expenses

      result.must_be_kind_of Array
      result.size.must_equal 2
      result.first.must_be_kind_of CrunchApi::Expense
    end
  end

  describe "a single expense in the collection" do
    it "returns an array with one expense in it" do
      xml = <<XML
            <crunchMessage>
              <expenses count="1" firstResut="0">
                <expense expenseId='1' resourceUrl='/1'><expenseDetails/></expense>
              </expenses>
            </crunchMessage>
XML

      result = CrunchApi::Response::ExpenseCollectionResponse.new(xml).expenses

      result.must_be_kind_of Array
      result.size.must_equal 1
      result.first.must_be_kind_of CrunchApi::Expense
    end
  end

  describe "a response returned with outcome=success" do
    it "is a success" do
      xml = "<crunchMessage outcome='success'></crunchMessage>"

      result = CrunchApi::Response::ExpenseCollectionResponse.new(xml)

      assert result.success?
    end
  end

  describe "a response returned with outcome=failure" do
    it "is not a success" do
      xml = "<crunchMessage outcome='failure'></crunchMessage>"

      result = CrunchApi::Response::ExpenseCollectionResponse.new(xml)

      refute result.success?
    end
  end
end

