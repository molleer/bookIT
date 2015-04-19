# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  allow_party :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  only_group  :boolean
#

require 'rails_helper'

describe Room do
  it "should have valid factories" do
  	build(:hubben).should be_valid
  	build(:grupprummet).should be_valid
  end

  it "should have unique names" do
    create(:hubben).should be_valid
    build(:hubben).should_not be_valid
  end
end
