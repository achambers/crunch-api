require_relative '../../test_helper'

describe CrunchApi::ExpenseItem do
  it "sets the attribute for expense type" do
    expense_item = CrunchApi::ExpenseItem.new(expense_type: "foo")

    expense_item.expense_type.must_equal "foo"
  end

  it "sets the attribute for description" do
    expense_item = CrunchApi::ExpenseItem.new(line_item_description: "foo")

    expense_item.description.must_equal "foo"
  end

  [:net_amount, :gross_amount, :vat_amount].each do |attribute|
    it "sets the attribute for #{attribute} " do
      expense_item = CrunchApi::ExpenseItem.new(attribute => "462.50")

      expense_item.send(attribute).must_be_kind_of Money
      expense_item.send(attribute).cents.must_equal 46250
      expense_item.send(attribute).currency.to_s.must_equal "GBP"
    end
  end
end
