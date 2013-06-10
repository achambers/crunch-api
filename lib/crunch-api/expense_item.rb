require 'money'

module CrunchApi
  class ExpenseItem
    attr_reader :expense_type, :description, :net_amount, :gross_amount, :vat_amount

    def initialize(attributes)
      @expense_type = attributes[:expense_type]
      @description = attributes[:line_item_description]
      @net_amount = Money.parse(attributes[:net_amount], "GBP")
      @gross_amount = Money.parse(attributes[:gross_amount], "GBP")
      @vat_amount = Money.parse(attributes[:vat_amount], "GBP")
    end
  end
end
