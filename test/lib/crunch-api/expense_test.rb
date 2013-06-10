require_relative '../../test_helper'

describe CrunchApi::Expense do
  before do
    CrunchApi.configure do |config|
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  describe "Initialization" do

    it "sets the attribute for id" do
      expense = CrunchApi::Expense.new(:id => 1)

      expense.id.must_equal 1
    end

    it "sets the attribute for uri" do
      expense = CrunchApi::Expense.new(uri: "foo")

      expense.uri.must_equal "foo"
    end

    describe "an expense with a supplier" do
      it "sets the attribute for supplier" do
        attributes = {
          expense_details: {
            supplier: {
              id: "1"
            }
          }
        }

        expense = CrunchApi::Expense.new(attributes)

        expense.supplier.must_be_kind_of CrunchApi::Supplier
        expense.supplier.id.must_equal 1
      end
    end

    describe "an expense without a supplier" do
      it "sets the supplier attribute to nil" do
        attributes = {}
        expense = CrunchApi::Expense.new(attributes)

        expense.supplier.must_be_nil
      end
    end

    it "sets an attributes for supplier reference" do
        attributes = {
          expense_details: {
            supplier_reference: "Test Reference"
          }
        }

        expense = CrunchApi::Expense.new(attributes)

        expense.supplier_reference.must_equal "Test Reference"
    end

    it "sets an attribute for expense date" do
        attributes = {
          expense_details: {
            posting_date: Date.new(2013, 01, 02)
          }
        }

        expense = CrunchApi::Expense.new(attributes)

        expense.date.must_be_kind_of Date
        expense.date.day.must_equal 2
        expense.date.month.must_equal 1
        expense.date.year.must_equal 2013
    end
  end

  describe "GET /expenses" do
    it "calls the correct resource" do
      VCR.use_cassette('get_expenses_success') do
        CrunchApi::Expense.all

        assert_requested(:get, "https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/expenses")
      end
    end

    it "returns an array of expenses" do
      VCR.use_cassette('get_expenses_success') do
        expenses = CrunchApi::Expense.all

        expenses.size.must_equal 2
        expenses.must_be_kind_of Array
        expenses.first.must_be_kind_of CrunchApi::Expense
        expenses.first.id.must_equal 2427
      end
    end
  end

  describe "GET /expenses/{id" do
    it "calls the correct url" do
      VCR.use_cassette("get_expense_by_id_success") do
        CrunchApi::Expense.for_id(2427)

         assert_requested(:get, "https://demo.crunch.co.uk/crunch-core/seam/resource/rest/api/expenses/2427")
      end
    end

    describe "an existing expense" do
      it "returns the correct expense" do
        VCR.use_cassette("get_expense_by_id_success") do
          expense = CrunchApi::Expense.for_id(2427)

          expense.must_be_kind_of CrunchApi::Expense
          expense.id.must_equal 2427
        end 
      end
    end

    describe "an unknown expense" do
      it "returns nil" do
        VCR.use_cassette('get_expense_by_id_failure') do
          expense = CrunchApi::Expense.for_id(999)

          expense.must_be_nil
        end
      end
    end
  end

end
