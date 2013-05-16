require_relative '../../test_helper'

describe CrunchApi do
  it "must be defined" do
    CrunchApi::VERSION.wont_be_nil
  end
end