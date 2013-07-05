require_relative '../../../test_helper'

describe CrunchApi::ResponseMapper::ExpenseCollectionMapper do
  describe "a collection of expenses" do
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

        result = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(xml).map

        result.must_be_kind_of Array
        result.size.must_equal 2
        assert result.first.has_key?(:expense_details)
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

        result = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(xml).map

        result.must_be_kind_of Array
        result.size.must_equal 1
        assert result.first.has_key?(:expense_details)
      end
    end
  end

  describe "mapping of properties" do
    before do
      @xml = <<XML
            <crunchMessage>
              <expenses count="1" firstResut="0">
                <expense expenseId='1' resourceUrl='/1'><expenseDetails/></expense>
              </expenses>
            </crunchMessage>
XML
    end

    it "snake cases basic properties" do
      result = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(@xml).map

      assert result.first.has_key?(:expense_details)
      refute result.first.has_key?(:expenseDetails) 
    end

    it "maps the expense id" do
      result = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(@xml).map

      result.first[:id].must_equal "1"
      refute result.first.has_key?(:expenseId) 
      refute result.first.has_key?(:expense_id) 

    end

    it "maps the expense uri" do
      result = CrunchApi::ResponseMapper::ExpenseCollectionMapper.new(@xml).map

      result.first[:uri].must_equal "/1"
      refute result.first.has_key?(:@resourceUrl) 
      refute result.first.has_key?(:@resource_url) 
    end
  end
end

