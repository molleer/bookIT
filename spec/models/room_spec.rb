require 'spec_helper'

describe Room do
  it "should have valid factories" do
  	build(:hubben).should be_valid
  	build(:grupprummet).should be_valid
  end
end